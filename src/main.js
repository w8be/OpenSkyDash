import { createApp } from 'vue'
import App from './App.vue'
import { registerPlugins } from './plugins'

// Check if we are running in production mode
if (import.meta.env.PROD) {
  console.log = () => {}
  console.warn = () => {}
  // console.error = () => {}; // Optional: Leave this out if you still want to see critical crashes
}

// import './assets/main.css' // Import your global styles here

const app = createApp(App)

registerPlugins(app) // This already calls app.use(vuetify) internally

app.mount('#app')
