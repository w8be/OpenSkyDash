import { createApp } from 'vue'
import App from './App.vue'
import { registerPlugins } from './plugins'

if (import.meta.env.PROD) {
  console.log = () => {}
  console.warn = () => {}
}

const app = createApp(App)

registerPlugins(app)

// // 1. Catch Vue-specific template & component crashes
// app.config.errorHandler = (err, vm, info) => {
//   const errorMessage = `🚨 VUE ERROR:\n${err.message}\n\nStack:\n${err.stack}\n\nInfo: ${info}`
//   alert(errorMessage)
//   console.error(err)
// }

// // 2. Catch standard JavaScript runtime errors (syntax, typos, etc.)
// window.onerror = function (message, source, lineno, colno, error) {
//   const errorMessage = `💥 JS ERROR:\n${message}\n\nFile: ${source}\nLine: ${lineno}:${colno}`
//   alert(errorMessage)
//   return false
// }

// // 3. Catch failed API calls or unhandled async/promise promises
// window.addEventListener('unhandledrejection', function (event) {
//   const errorMessage = `⏳ PROMISE REJECTION:\n${event.reason}`
//   alert(errorMessage)
// })

app.mount('#app')
