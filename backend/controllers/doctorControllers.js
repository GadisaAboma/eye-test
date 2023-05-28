const Doctor = require('../models/doctor')

const registerDoctor = async(req, res) => {
    
    const { name, email, password } = req.body

    const isExist = await Doctor.findOne({email: email})

    if(isExist) {
       return res.status(400).json({message: "This email is already taken!"})
    }

    const doctor = new Doctor({
        name,
        email,
        password
    })

   const newDoctor =  await doctor.save()

   if(newDoctor) {
    res.status(201).json(newDoctor)
   } else {
    res.status(400).json({message: "Registration failed", error: "Registration failed"})
   }
        
    
}

const loginDoctor = async (req, res) => {
    console.log('in her')
    const { email, password } = req.body
    
    const doctor = await Doctor.findOne({email: email});
    if((doctor && doctor.password === password)) {
        res.status(200).json(doctor)
    } else {
        res.status(400).json({message: "Invalid credentials"})
    }
}


module.exports = { registerDoctor, loginDoctor}