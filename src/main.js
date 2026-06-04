import { createApp } from 'vue'
import App from './App.vue'
import { registerPlugins } from './plugins'

if (import.meta.env.PROD) {
  console.log = () => {}
  console.warn = () => {}
}

const app = createApp(App)

registerPlugins(app)

app.mount('#app')
