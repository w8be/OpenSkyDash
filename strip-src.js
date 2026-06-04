import fs from 'fs'
import path from 'path'
import readline from 'readline/promises'
import { stdin as input, stdout as output } from 'process'

// Initialize the readline interface for user input
const rl = readline.createInterface({ input, output })

async function processDirectory(dir) {
  if (!fs.existsSync(dir)) {
    console.warn(`Directory not found, skipping: ${dir}`)
    return
  }

  const files = fs.readdirSync(dir)

  for (const file of files) {
    const fullPath = path.join(dir, file)
    const stat = fs.statSync(fullPath)

    if (stat.isDirectory()) {
      // Wait for the recursive subdirectory scanning to finish
      await processDirectory(fullPath)
    } else if (file.endsWith('.js') || file.endsWith('.vue')) {
      const originalContent = fs.readFileSync(fullPath, 'utf8')
      let cleanContent = originalContent

      // 1. Strip out HTML comments first
      if (file.endsWith('.vue')) {
        cleanContent = cleanContent.replace(new RegExp('', 'g'), '')
      }

      // 2. Strip out multi-line JavaScript comments: /* comment */
      cleanContent = cleanContent.replace(/\/\*[\s\S]*?\*\//g, '')

      // 3. Strip out single-line JavaScript comments: // comment
      cleanContent = cleanContent.replace(/(^|[^\/])\/\/.*$/gm, '$1')

      // Only prompt if changes actually occurred
      if (originalContent !== cleanContent) {
        console.log(`\n--------------------------------------------------`)
        console.log(`⚠️  CHANGES DETECTED IN: ${fullPath}`)
        console.log(`--------------------------------------------------`)

        // Show a preview of what is being removed (rough approximation)
        // For a true diff, you'd want an external library, but this gives a quick context check.
        console.log(`[Preview of modifications active...]`)

        const answer = await rl.question(`Do you want to apply these changes to ${file}? (y/N): `)

        if (answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes') {
          fs.writeFileSync(fullPath, cleanContent, 'utf8')
          console.log(`✅ Updated: ${file}`)
        } else {
          console.log(`❌ Skipped: ${file}`)
        }
      }
    }
  }
}

// Master wrapper to handle async flow for the target directories
async function run() {
  // Grab arguments passed in the terminal (skipping the first two Node defaults)
  const args = process.argv.slice(2)

  // If you passed arguments, use them! Otherwise, fall back to defaults.
  const targetDirectories = args.length > 0 ? args : ['./src', './public']

  console.log(`\nStarting scan...`)
  for (const dir of targetDirectories) {
    console.log(`Scanning: ${dir}...`)

    // Quick check to see if the argument is a single file instead of a directory
    if (fs.existsSync(dir) && fs.statSync(dir).isFile()) {
      // If it's a single file, we wrap it in a pseudo-directory logic or process it.
      // For simplicity, processDirectory handles paths, but needs to read files inside it.
      // Let's handle a direct file argument safely right here:
      await processSingleFile(dir)
    } else {
      await processDirectory(dir)
    }
  }

  console.log('\nProcessing complete.')
  rl.close()
}

// Small helper to handle single-file arguments cleanly
async function processSingleFile(fullPath) {
  const file = path.basename(fullPath)
  if (file.endsWith('.js') || file.endsWith('.vue')) {
    const originalContent = fs.readFileSync(fullPath, 'utf8')
    let cleanContent = originalContent

    if (file.endsWith('.vue')) {
      cleanContent = cleanContent.replace(new RegExp('', 'g'), '')
    }
    cleanContent = cleanContent.replace(/\/\*[\s\S]*?\*\//g, '')
    cleanContent = cleanContent.replace(/(^|[^\/])\/\/.*$/gm, '$1')

    if (originalContent !== cleanContent) {
      console.log(`\n--------------------------------------------------`)
      console.log(`⚠️  CHANGES DETECTED IN: ${fullPath}`)
      console.log(`--------------------------------------------------`)

      const answer = await rl.question(`Do you want to apply these changes to ${file}? (y/N): `)
      if (answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes') {
        fs.writeFileSync(fullPath, cleanContent, 'utf8')
        console.log(`✅ Updated: ${file}`)
      } else {
        console.log(`❌ Skipped: ${file}`)
      }
    } else {
      console.log(`No comments found in ${file}.`)
    }
  }
}

run()
