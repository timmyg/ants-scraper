{Article, request} = require '../vars'

it "birds should fly", ->
	1.should.equal 1

describe 'requesting root page', ->

	it 'should respond with a 200', (done) ->
		request.get
			url: "http://localhost:3000/v1"
		, (error, response, body) ->
			response.statusCode.should.equal 200
			done()


describe 'ensuring database working', ->

	it 'test should respond with a 200', (done) ->
		# this is created in before.coffee
		# and destroyed in after.coffee
		Article.findOne
			title: "Testy Mctesterson"
		, (err, article) ->
			article.should.exist
			done()


describe 'getting api keys', ->
	describe 'mixpanel', ->
		it 'should respond with a 400 since project name already used', (done) ->
			data =
				"username": "timmyg13@gmail.com" 
				"password": "orange13"
				"project": "project123"
			request.post
				url: "http://localhost:3000/v1/node/mixpanel"
				body: data
			, (error, response, body) ->
				console.log error if error
				console.log "reeeesponse", response.statusCode
				console.log body
				console.log "\n\n\n\n"
				response.statusCode.should.equal 400
				should.exist body.keys[0]["MIXPANEL_TOKEN"]
				body.keys[0]["MIXPANEL_TOKEN"].length.should.be.at.least 10
				done()