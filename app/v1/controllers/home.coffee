homeController = {}
v = require "#{process.env.PWD}/config/vars"
Nightmare = require 'nightmare'
_ = require 'underscore'
mongoose = require "mongoose"
moment = require "moment"
cheerio = require "cheerio"
request = require("request").defaults(json: true)
Pushover = require('pushover-notifications')
pushover = new Pushover
  user: process.env.PUSHOVER_USER
  token: process.env.PUSHOVER_TOKEN
  priority: 1 # high
require "#{v.PATH.v1.MODELS}/alert"
Alert = mongoose.models.Alert
require "#{v.PATH.v1.MODELS}/concert"
Concert = mongoose.models.Concert
ANTS_TIME_LABEL = "ants-timer"
COT_TIME_LABEL = "cot-timer"
TIMER_SECONDS = 90 
i = 0
i2 = 0

# callAnts = ->
# 	console.log "call ants"
# 	request.get {url: "http://ants-scraper.herokuapp.com/v1/ants"}, (error, response, body) ->
# setInterval callAnts, TIMER_SECONDS * 1000

callCashOrTrade = ->
	console.log "call cashortrade"
	request.get {url: "http://ants-scraper.herokuapp.com/v1/cashortrade"}, (error, response, body) ->
setInterval callCashOrTrade, TIMER_SECONDS * 1000

homeController.index = (req, res) ->
	return res.sendStatus 200

homeController.cashortrade = (req, res) ->
	console.time "#{COT_TIME_LABEL}-#{i2}"
	getConcertKeywords (err, keywords)->
		console.log "1"
		(new Nightmare)
		.goto('https://cashortrade.org/dave-matthews-band-tickets?cash_or_trade=1')
		.wait()
		.evaluate((->
			document
		), (doc) ->
			console.log "2"
			html = doc.all['0'].innerHTML
			console.log "cot html", html
			$ = cheerio.load(html)
			$('.face-value').each (i, elem) ->
				console.log "3"
				title = $(this).text().trim()
				id =  $(this)['0'].attribs.href.split("/")[4]
				path =  $(this)['0'].attribs.href
				console.log "4"
				console.log "cashortrade:", title, id, path
				console.log "5"
				relevantConcert = isCoolConcert title, id, path, keywords
				return console.info "not relevant" unless relevantConcert
				isAlreadySent path, (err, alert) ->
					console.log "6"
					return console.info "already created #{path}" if alert
					link = "https://cashortrade.org#{path}"
					Alert.create
						href: path
					, (err, alert) ->	
						sendAlert title, link
		).run(->
			console.log "7"
			console.timeEnd "#{COT_TIME_LABEL}-#{i2}"
			i2++
			return res.sendStatus 201
		)


homeController.ants = (req, res) ->
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"
	console.log "- - - - - -  RUNNING ants #{moment().format()} - - - - - -"
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"
	console.log "-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%-+=][';>|]+-&^$&(@%<"

	console.time "#{ANTS_TIME_LABEL}-#{i}"
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
			console.timeEnd "#{ANTS_TIME_LABEL}-#{i}"
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
		priority: 1
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
