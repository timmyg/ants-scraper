homeController = {}
v = require "#{process.env.PWD}/config/vars"
Nightmare = require 'nightmare'
_ = require 'underscore'
mongoose = require "mongoose"
cheerio = require "cheerio"
Pushover = require('pushover-notifications')
pushover = new Pushover(
  user: "grreasujfdiYNrNyhHKBNk3NtnGGjL"
  token: "aYMA76EHGjGf26X2UbNGqNnyMnvV3y")
require "#{v.PATH.v1.MODELS}/alert"
Alert = mongoose.models.Alert
require "#{v.PATH.v1.MODELS}/concert"
Concert = mongoose.models.Concert

homeController.index = (req, res) ->
	return res.sendStatus 200

homeController.ants = (req, res) ->
	getConcertKeywords (err, keywords)->
		(new Nightmare)
		.goto('http://antsmarching.org/forum/forumdisplay.php?f=11')
		.type('input.bginput#navbar_username', 'timmyg013')
		.type('input.bginput#navbar_password', 'orange13')
		.screenshot('test/ants-before-login.png')
		.click('input.button[type="submit"][value="Log in"]')
		.wait()
		.goto('http://antsmarching.org/forum/forumdisplay.php?f=11')
		.screenshot('test/ants-after-login-1.png')
		.wait()
		.screenshot('test/ants-after-login-2.png')
		.evaluate((->
			document
		), (doc) ->
			html = doc.all['0'].innerHTML
			$ = cheerio.load(html)
			$('[id^=thread_title]').each (i, elem) ->
				title = $(this).parent().text().trim().replace(/(\r\n|\n|\r)/gm,"")
				id =  $(this)['0'].attribs.id
				path =  $(this)['0'].attribs.href
				relevantConcert = isCoolConcert title, id, path, keywords
				return console.info "not relevant" unless relevantConcert
				isAlreadySent path, (err, alert) ->
					return console.info "already created #{path}" if alert
					link = "http://antsmarching.org/forum/#{path}"
					Alert.create
						href: path
					, (err, alert) ->	
						sendAlert title, link
		).run(->
			return res.sendStatus 201
		)


sendAlert = (title, link) ->
	msg = 
		message: "#{title} #{link}"
		url: link
		title: 'Ants alert'
	pushover.send msg, (err, result) ->
		console.error err if err

isCoolConcert = (title, id, path, keywords) ->
	title = title.toLowerCase()
	if isSale title
		unless isLawn title
			if isRelevantConcert title, keywords
				return true
	return false

isAlreadySent = (path, callback) ->
	Alert.findOne
		href: path
	, (err, alert) ->
		return callback err, alert

isSale = (title) ->
	title = title.toLowerCase()
	return false unless title and title.length
	title.indexOf("sale") > -1 or title.indexOf("fs") > -1

isLawn = (title) ->
	title = title.toLowerCase()
	title.indexOf("lawn") > -1


isRelevantConcert = (title, keywords) ->
	title = title.toLowerCase()
	relevant = false
	for concert in keywords
		if title.indexOf(concert) > -1
			relevant = true
			break
	relevant


getConcertKeywords = (callback) ->
	Concert.find (err, concerts) ->
		keywords = []
		for concert in concerts
			keywords = keywords.concat concert.keywords
		callback err, keywords


module.exports = homeController
