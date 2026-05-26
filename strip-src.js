// strip-src.js
import fs from 'fs'
import path from 'path'
import strip from 'strip-comments'

function processDirectory(dir) {
  const files = fs.readdirSync(dir)

  files.forEach((file) => {
    const fullPath = path.join(dir, file)
    const stat = fs.statSync(fullPath)

    if (stat.isDirectory()) {
      processDirectory(fullPath) // Recursive scan for subdirectories
    } else if (file.endsWith('.js') || file.endsWith('.vue')) {
      const content = fs.readFileSync(fullPath, 'utf8')

      // Strip out comments but preserve code whitespace structure
      const cleanContent = strip(content, { preserveNewlines: true })

      fs.writeFileSync(fullPath, cleanContent, 'utf8')
    }
  })
}

// Target your source directory
processDirectory('./src')
console.log('Successfully stripped all comments from src/ directory.')
