const express = require('express')

const { wrapAsync, checkId } = require('../utils/utils')
const registersController = require('../controllers/registersController')

const router = express.Router()

/* Routes. */
router.get('/registers/today/all', wrapAsync(registersController.getAllTodayRegisters))

router.patch('/registers/call/pet/id/:id', checkId, wrapAsync(registersController.callRegisterPet))
router.patch('/registers/finish/pet/id/:id', checkId, wrapAsync(registersController.finishInquiryPet))

module.exports = router
