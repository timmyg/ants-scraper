express = require 'express'
router = express.Router()

homeController = require "./controllers/home"

router.get '/', homeController.index
# router.get '/stripe', homeController.stripe
router.post '/node/mixpanel', homeController.mixpanel
# router.get '/dropbox', homeController.dropbox
router.get '/ants', homeController.ants

module.exports = router