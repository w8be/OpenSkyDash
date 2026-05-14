const express = require('express')
const path = require('path')
const app = express()
const port = process.env.PORT || 5050

app.use(express.static(path.join(__dirname, 'dist')))

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'))
})

app.listen(port, () => {
  console.log(`Station-Dashboard running on port ${port}`)
})

app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'ok', uptime: process.uptime() })
})
