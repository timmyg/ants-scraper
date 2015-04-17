express = require 'express'
config = require './config/config'
glob = require 'glob'
mongoose = require 'mongoose'
mongoose.connect config.db
db = mongoose.connection
db.on 'error', ->
  throw new Error('unable to connect to database at ' + config.db)
  return
models = glob.sync(config.root + '/app/models/*.coffee')
models.forEach (model) ->
  require model
  return
app = express()
require('./config/express') app, config
app.listen config.port