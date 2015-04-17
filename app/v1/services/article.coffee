# # example service

# articleService = {}
# v = require "#{process.env.PWD}/config/vars"
# h = require "#{v.HELPERS}"
# require "#{v.PATH.v1.MODELS}/article"
# Article = mongoose.models.Article

# # this should probably be on model itself
# # but just an example of a service

# articleService.createTest = (data, callback) ->
# 	Article.create
# 		data: data
# 		test: true
# 	, (err, log) ->
# 		console.error err if err
# 		return callback err if err
# 		callback null, log

		
# module.exports = articleService
