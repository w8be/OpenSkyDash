import { reactive, watch } from 'vue'
// Import your master default object
import { settings } from './components/cards/dashboardSettings.js'

// 1. Try to grab the last saved session from the browser
const saved = localStorage.getItem('station_dashboard_v1')
const initialData = saved ? JSON.parse(saved) : settings

// 2. Create the live reactive state
export const globalState = reactive(initialData)

watch(
  globalState,
  (newState) => {
    localStorage.setItem('station_dashboard_v1', JSON.stringify(newState))
  },
  { deep: true },
)

window.G_STATE = globalState
