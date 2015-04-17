# Example model

mongoose = require 'mongoose'
Schema   = mongoose.Schema

AlertSchema = new Schema(
  href: String
)

# AlertSchema.virtual('date')
#   .get (-> this._id.getTimestamp())

mongoose.model 'Alert', AlertSchema

