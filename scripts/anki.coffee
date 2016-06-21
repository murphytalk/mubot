module.exports = (robot) ->
  robot.respond /anki (.*)/i, (msg) ->
    word = msg.match[1]

    dict_url = "http://api.pearson.com/v2/dictionaries/ldoce5/entries?headword=#{word}&limit=1"
    robot.http(dict_url)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err | res.statusCode != 200
        msg.send "Master, something is wrong with my dictionary!"
      else
        data = JSON.parse body
        if data.status != 200 or data.count == 0
          msg.send "Master, are you sure '#{word}' is a real word?"
        else
          msg.send data.results[0].senses[0].definition[0]

###    url = "http://127.0.0.1:27701/collection/murphy/add_note"
    robot.http(url)
    .header('Accept', 'text/plain')
    .post() (err, res, body) ->
      if err | res.statusCode != 200
        msg.send "Master, Anki server returns error, the status code is #{res.statusCode}"
      else
        msg.send ""###
