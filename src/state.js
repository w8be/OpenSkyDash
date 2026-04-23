import { reactive } from 'vue'

export const globalState = reactive({
  lightning: { frequency: 0 },
  solar: { flux: 0, isAlert: false }, // New bucket
  weather: {
    isRaining: false,
    conditionText: 'Clear', // New
    icon: 'mdi-weather-sunny', // New
    temp: 0, // New
  },
  localConfig: {
    searchRadius: 50,
    homeLocation: { lat: 39.2562, lon: -77.92504 }, // Set your default here
    sampleSize: 5,
    // ... rest of your config
  },
})
window.G_STATE = globalState
