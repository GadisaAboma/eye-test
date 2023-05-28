const mongoose = require('mongoose')

const connectDB = async () => {
    const response = await mongoose.connect(`mongodb://127.0.0.1:27017?retryWrites=true&w=majority`, {
        useNewUrlParser: true,
        useUnifiedTopology: false,
        serverSelectionTimeoutMS: 200000
    })

    console.log("MongoDB Connected: " + response.connection.host)

}

module.exports = { connectDB}