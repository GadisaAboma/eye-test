const mongoose = require('mongoose')

const Schema = mongoose.Schema

const patientSchema = Schema({
    name: {
        type: String,
        required: true
    },
    gender: {
        type: String,
        required: true
    },
    age: {
        type: String,
        required: true
    },
    id: {
        type: String,
        required: true,
        unique: true
    },
    picture: {
        type: String,
        required: true
    }

})

module.exports = mongoose.model('Patient', patientSchema)