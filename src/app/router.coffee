credentials = {}	# AWS credentials
url = ""	# AWS access url

dynasty = require('../dynasty.js')(credentials, url)

module.exports = (app) ->
  app.get '/', (req, res) ->
    res.sendfile './app/index.html'
    return
  app.delete '/api/conditionalDelete', (req, res) ->
    table = req.query.table
    key = req.query.key

    dynasty.table(table).remove key, {
      conditionExpression: '#use_count = :zero'
      expressionAttributeValues: ':zero': 0
    }, (e, r) ->
      if e
        res.send JSON.stringify(
          error: e
          data: null)
      else
        res.send JSON.stringify(
          error: null
          data: r)
      return
    return
  return