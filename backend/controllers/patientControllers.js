const Patient = require("../models/patient")


const registerPatient = async (req, res) => {
       
    const { name, age, gender, id} = req.body;
    const isExist = await Patient.findOne({id: id})

    if(isExist) {
        return res.status(400).json({message: "Patient with this id already exists!"})
    }
    
    const patient = new Patient({
        name,
        age, 
        gender,
        picture: req.file.path,
         id
    })
    const newPatient = await patient.save()

    if (newPatient) {
        res.status(201).json({message: 'Scucessfully registered'})
    } else {
        res.status(400).json( {message: "Unable to register patient"})
    }
}

const findPatient = async (req, res) => {
       
    const { name, id} = req.body;
    const isExist = await Patient.findOne({id: id, name: name})

    if(isExist) {
        return res.status(200).json(isExist)
    } else {
        return res.status(400).json({message: "Coudn't find a patient with this id and name"})
    }
    
    
}

module.exports = {registerPatient, findPatient}