homeController = {}
v = require "#{process.env.PWD}/config/vars"
Nightmare = require 'nightmare'
_ = require 'underscore'
mongoose = require "mongoose"
cheerio = require "cheerio"
request = require("request").defaults(json: true)
Pushover = require('pushover-notifications')
pushover = new Pushover(
  user: process.env.PUSHOVER_USER
  token: process.env.PUSHOVER_TOKEN)
require "#{v.PATH.v1.MODELS}/alert"
Alert = mongoose.models.Alert
require "#{v.PATH.v1.MODELS}/concert"
Concert = mongoose.models.Concert
TIME_LABEL = "ants"
i = 0

callAnts = ->
  request.get {url: "http://ants-scraper.herokuapp.com/v1/ants"}, (error, response, body) ->

# every 90 seconds
setInterval callAnts, 90 * 1000

homeController.index = (req, res) ->
	return res.sendStatus 200

homeController.ants = (req, res) ->
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"
	console.log "- - - - - - - - - - - - - RUNNING - - - - - - - - - - - - -"
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"

	console.time "TIME_LABEL-#{i}"
	getConcertKeywords (err, keywords)->
		console.log "keywords:", keywords
		(new Nightmare)
		.goto('http://antsmarching.org/forum/forumdisplay.php?f=11')
		.type('input.bginput#navbar_username', process.env.ANTS_USER)
		.type('input.bginput#navbar_password', process.env.ANTS_PASSWORD)
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
			console.log "ants html", html
			$ = cheerio.load(html)
			$('[id^=thread_title]').each (i, elem) ->
				title = $(this).parent().text().trim().replace(/(\r\n|\n|\r)/gm,"")
				console.log "thread title:", title
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
			console.timeEnd "TIME_LABEL-#{i}"
			i++
			return res.sendStatus 201
		)

homeController.sendTest = (req, res) ->
	sendAlert "Test Alert", "https://www.espn.com"
	return res.sendStatus 201

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
