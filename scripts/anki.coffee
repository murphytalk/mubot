root = exports ? this

root.count = 1
root.meaning = ''
root.pronunciation = ''
root.example = ''

reset = ->
  root.count = 1
  root.meaning = ''
  root.pronunciation = ''
  root.example = ''

parse_result = (result) ->
  root.meaning = "#{root.meaning}#{root.count}-(#{result.part_of_speech}) " + (if result.senses[0].definition? then result.senses[0].definition else result.senses[0].signpost) + '\n'
  root.pronunciation = "#{root.pronunciation}#{root.count}-" + (if result.pronunciations? then result.pronunciations[0].ipa else '') + '\n'
  root.example = "#{root.example}#{root.count}-" + (if result.senses[0].examples? then result.senses[0].examples[0].text else '') + '\n'
  root.count++


lookup_dict = (robot, word, msg) ->
  dict_url = "http://api.pearson.com/v2/dictionaries/ldoce5/entries?headword=#{word}"
  robot.http(dict_url)
  .header('Accept', 'application/json')
  .get() (err, res, body) ->
    if err or res.statusCode != 200
      msg.send "Master, something is wrong with my dictionary!"
    else
      data = JSON.parse body
      if data.status != 200 or data.count == 0
        msg.send "Master, are you sure '#{word}' is a real word?"
      else
        parse_result result for result in data.results when result.headword is word
        msg.send "Meaning:\n#{root.meaning}Pronunciation:\n#{root.pronunciation}Examples:\n#{root.example}"

add_word_to_anki = (robot, msg, word) ->
    anki_url = "http://127.0.0.1:27701/collection/murphy/add_note"
    #todo: post data
    robot.http(anki_url)
    .header('Accept', 'text/plain')
    .post() (err, res, body) ->
      if err or res.statusCode != 200
        msg.send "Master, something is wrong with Anki, its status code is #{res.statusCode}"
      else
        msg.send "Added to Anki:#{word}\n#{meaning}"


module.exports = (robot) ->
  robot.respond /dict (.*)/i, (msg) ->
    reset()
    word = msg.match[1]
    lookup_dict robot, word, msg

  robot.respond /anki (.*)/i, (msg) ->
    reset()
    word = msg.match[1]
    add_word_to_anki robot, msg, word
