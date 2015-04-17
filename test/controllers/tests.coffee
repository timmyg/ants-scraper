{ request} = require '../vars'

it "birds should fly", ->
	1.should.equal 1

describe 'requesting root page', ->

	it 'should respond with a 200', (done) ->
		request.get
			url: "http://localhost:3000/v1"
		, (error, response, body) ->
			response.statusCode.should.equal 200
			done()