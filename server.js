import express from 'express'
import cors from 'cors'
import path from 'path'
import { fileURLToPath } from 'url'
import fs from 'fs'

// Setup for ES Modules __dirname
const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
const port = process.env.PORT || 5050

app.use(cors())

app.get('/blitz-js', async (req, res) => {
  try {
    // We fetch the dynamic JS from Blitzortung's server
    const response = await fetch('https://www.blitzortung.org/blitzortung.php?layout=0')
    const data = await response.text()

    // We pass that script text right through to your frontend
    res.send(data)
  } catch (error) {
    console.error('Error fetching Blitzortung script:', error)
    res.status(500).send('Could not fetch lightning data')
  }
})

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
app.get(/^(?!\/(api|blitz-js)).+/, (req, res) => {
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
