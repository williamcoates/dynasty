express = require('express')
app = express()
bodyParser = require('body-parser')
methodOverride = require('method-override')

port = process.env.PORT or 3000

app.use bodyParser.json()
app.use bodyParser.json(type: 'application/vnd.api+json')
app.use bodyParser.urlencoded(extended: true)
app.use methodOverride('X-HTTP-Method-Override')
app.use express.static(__dirname + '/public')
  
require('./app/router.js') app

app.listen port, ->
  console.log 'Dynasty server running on port ' + port
  return

module.exports = app