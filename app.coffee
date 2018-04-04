express = require 'express'
require('dotenv').config()
config = require './config/config'
glob = require 'glob'
mongoose = require 'mongoose'
mongoose.connect config.db
db = mongoose.connection
# db.on 'error', ->
#   throw new Error('unable to connect to database at ' + config.db)
#   return
db.on "connecting", () =>
  console.info("Connecting to MongoDB...");

db.on "error", (error) =>
  console.error("MongoDB connection error: ${error}");
  # mongoose.disconnect();

db.on "reconnected", () =>
  console.info("MongoDB reconnected!");

db.on "disconnected", () =>
  console.error("MongoDB disconnected!");
  # setTimeout(() => connect(), reconnectTimeout);

db.on "connected", () =>
  console.info("Connected to MongoDB!");

db.once "open", () => 
  console.info("MongoDB connection opened!");
  # startup();

models = glob.sync(config.root + '/app/v1/models/*.coffee')
models.forEach (model) ->
  require model
  return
app = express()
require('./config/express') app, config
app.listen config.port