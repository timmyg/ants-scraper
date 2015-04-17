# # this runs once after tests are ran
{Article} = require './vars'

after (done) ->
	Article.remove
		title: "Testy Mctesterson"
	, (err, article) ->
		done()