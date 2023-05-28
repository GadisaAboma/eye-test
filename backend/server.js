const express = require('express')
const cors = require('cors')
const  { connectDB }  = require( './config/db');
const doctorRoutes = require('./routes/doctorRoutes')
const patientRoutes = require('./routes/patientRoutes')

const app = express()
app.use('/uploads', express.static('uploads'))
app.use(cors())

app.use(express.json())


app.use('/api/patients', patientRoutes)
app.use('/api/doctors', doctorRoutes)

app.listen(4000, () => {
    console.log('Server is up and running on port '+4000);
})

connectDB()