mongoose = require 'mongoose'
Schema   = mongoose.Schema

ConcertSchema = new Schema(
  keywords: Array
  name: String
)

mongoose.model 'Concert', ConcertSchema

