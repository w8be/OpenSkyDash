import fs from 'fs'
import path from 'path'

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
      let cleanContent = fs.readFileSync(fullPath, 'utf8')

      // 1. Strip out HTML comments first
      if (file.endsWith('.vue')) {
        cleanContent = cleanContent.replace(new RegExp('', 'g'), '')
      }

      // 2. Strip out multi-line JavaScript comments: /* comment */
      cleanContent = cleanContent.replace(/\/\*[\s\S]*?\*\//g, '')

      // 3. Strip out single-line JavaScript comments: // comment
      cleanContent = cleanContent.replace(/(^|[^\/])\/\/.*$/gm, '$1')

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
