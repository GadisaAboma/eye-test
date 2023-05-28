const express = require('express')
const { registerDoctor, loginDoctor } = require('../controllers/doctorControllers')

const router = express.Router()

router.post('/login-doctor', loginDoctor)
router.post('/register-doctor', registerDoctor)


module.exports = router;