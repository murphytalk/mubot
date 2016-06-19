module.exports = (robot) ->
   robot.hear /trans/i, (msg) ->
       url = "http://localhost:8080/db/trans.json"
       robot.http(url)
           .header('Accept', 'application/json')
           .get() (err, res, body) ->
                 if err | res.statusCode != 200
                     msg.send "Error,Status code is #{res.statusCode}"
                 else
                     msg.send "body is #{body}"
