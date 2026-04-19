import { reactive } from 'vue'

export const globalState = reactive({
  lightning: { frequency: 0 },
  solar: { flux: 0, isAlert: false }, // New bucket
  weather: { isRaining: false }, // New bucket
})
window.G_STATE = globalState
