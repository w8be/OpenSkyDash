import express from 'express'
import path from 'path'
import { fileURLToPath } from 'url'
import fs from 'fs'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const app = express()
const port = process.env.PORT || 5050

// 1. Static Files (Standard Vuetify/Vite build output)
app.use(express.static(path.join(__dirname, 'dist')))

// 2. Specific API Routes (Must come BEFORE the wildcard)
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  })
})

// 3. Catch-all Wildcard (Must come LAST)
app.get('*', (req, res) => {
  const indexPath = path.join(__dirname, 'dist', 'index.html')

  if (fs.existsSync(indexPath)) {
    res.sendFile(indexPath)
  } else {
    res.status(404).send('Dashboard build files (dist) not found. Did you run npm run build?')
  }
})

app.listen(port, () => {
  console.log(`Station-Dashboard running on port ${port}`)
})
