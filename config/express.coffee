express = require 'express'
glob = require 'glob'

favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
compress = require 'compression'
methodOverride = require 'method-override'
exphbs  = require 'express-handlebars'
moment  = require 'moment'

v1 = require '../app/v1/routes'

module.exports = (app, config) ->
  app.engine 'handlebars', exphbs(
    layoutsDir: config.root + '/app/v1/views/layouts/'
    defaultLayout: 'main'
    partialsDir: [config.root + '/app/v1/views/partials/']
  )
  app.set 'views', config.root + '/app/v1/views'
  app.set 'view engine', 'handlebars'

  # app.use(favicon(config.root + '/public/img/favicon.ico'));
  app.use logger 'dev'
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(
    extended: true
  )
  app.use cookieParser()
  app.use compress()
  app.use express.static config.root + '/public'
  app.use methodOverride()

  controllers = glob.sync config.root + '/app/controllers/**/*.coffee'
  controllers.forEach (controller) ->
    require(controller)(app);

  app.use "/v1", v1

  # catch 404 and forward to error handler
  app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

  # error handlers

  # development error handler
  # will print stacktrace
  
  if app.get('env') == 'development'
    app.use (err, req, res, next) ->
      res.status err.status || 500
      res.render 'error',
        message: err.message
        error: err
        title: 'error'

  # production error handler
  # no stacktraces leaked to user
  app.use (err, req, res, next) ->
    res.status err.status || 500
    res.render 'error',
      message: err.message
      error: {}
      title: 'error'

  console.info "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
  console.info "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  console.info "Running at http://localhost:#{config.port} #{moment().format()}"
  console.info "Connected to", config.db
  console.info "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  console.info "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
