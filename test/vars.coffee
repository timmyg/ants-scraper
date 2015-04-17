mongoose = require "mongoose"
v = require "#{process.env.PWD}/config/vars"
require "#{v.PATH.v1.MODELS}/article"
exports.request = require("request").defaults(json: true)
exports.Article = mongoose.models.Article

module.exports = exports