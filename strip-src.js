// strip-src.js
import fs from 'fs'
import path from 'path'
import strip from 'strip-comments'

function processDirectory(dir) {
  // Failsafe in case a directory doesn't exist
  if (!fs.existsSync(dir)) {
    console.warn(`Directory not found, skipping: ${dir}`)
    return
  }

  const files = fs.readdirSync(dir)

  files.forEach((file) => {
    const fullPath = path.join(dir, file)
    const stat = fs.statSync(fullPath)

    if (stat.isDirectory()) {
      processDirectory(fullPath) // Recursive scan for subdirectories
    } else if (file.endsWith('.js') || file.endsWith('.vue')) {
      const content = fs.readFileSync(fullPath, 'utf8')

      // 1. Strip out standard JS/CSS comments
      let cleanContent = strip(content, { preserveNewlines: true })

      // 2. Strip out HTML comments specifically for Vue template blocks
      if (file.endsWith('.vue')) {
        // This RegEx targets cleanContent = cleanContent.replace(//g, '')
      }

      fs.writeFileSync(fullPath, cleanContent, 'utf8')
    }
  })
}

// Target multiple directories using an array
const targetDirectories = ['./src', './public']

// Loop through your targets and process each one
targetDirectories.forEach((dir) => {
  console.log(`Scanning directory: ${dir}...`)
  processDirectory(dir)
})

console.log('Successfully stripped all comments from target directories.')
