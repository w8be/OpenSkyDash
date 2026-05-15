import express from 'express'
import path from 'path'
import { fileURLToPath } from 'url'
import fs from 'fs'

// Setup for ES Modules __dirname
const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
const port = process.env.PORT || 5050

// 1. Serve static files from the 'dist' folder
app.use(express.static(path.join(__dirname, 'dist')))

// 2. Health Check API (Always put specific API routes BEFORE the wildcard)
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  })
})

// 3. The Wildcard Catch-All (Satisfies Node v24/Express 5 strictness)
// Using (.*) is a foolproof way to catch every other path for the SPA
app.get(/^(?!\/api).+/, (req, res) => {
  const indexPath = path.join(__dirname, 'dist', 'index.html')

  if (fs.existsSync(indexPath)) {
    res.sendFile(indexPath)
  } else {
    res.status(404).send('Dashboard build files (dist) not found. Check your build process.')
  }
})

app.listen(port, () => {
  console.log(`Station-Dashboard running on port ${port}`)
})
