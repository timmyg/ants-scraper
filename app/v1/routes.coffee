express = require 'express'
router = express.Router()

homeController = require "./controllers/home"

router.get '/', homeController.index
router.get '/ants', homeController.ants
router.get '/send/test', homeController.sendTest

module.exports = router