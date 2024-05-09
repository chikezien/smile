const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  console.log("i am here....")
  res.status(200).json( { "message": "Hello Smile" })
})


app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
  })