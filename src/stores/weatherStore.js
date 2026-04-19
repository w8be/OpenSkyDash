import { defineStore } from 'pinia'

export const useWeatherStore = defineStore('weather', {
  state: () => ({
    lightningFreq: 0,
    isStorming: false,
    currentTemp: '--',
  }),
})
