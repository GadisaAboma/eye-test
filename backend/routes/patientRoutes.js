const express = require('express')
const { registerPatient, findPatient } = require('../controllers/patientControllers')
const router = express.Router()

const multer = require('multer')

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './uploads/')
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname);
    }
})

const upload = multer({ storage: storage })

router.post('/register-patient', upload.single('picture'), registerPatient)
router.post('/find-patient', findPatient)


module.exports = router;