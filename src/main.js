import { createApp } from 'vue'
import App from './App.vue'
import { registerPlugins } from './plugins'

// import './assets/main.css' // Import your global styles here

const app = createApp(App)

registerPlugins(app) // This already calls app.use(vuetify) internally

app.mount('#app')
