express = require 'express'
router = express.Router()

homeController = require "./controllers/home"

router.get '/', homeController.index
router.get '/ants', homeController.ants

module.exports = router