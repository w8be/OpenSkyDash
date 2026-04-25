import { reactive } from 'vue'

const defaultSettings = reactive({
  // LIGHTNING CONFIGURATION
  lightning: {
    // User-adjustable values
    searchRadius: 50,
    alertThreshold: 25,
    areaThreshold: 50,
    unit: 'Mi',
    homeLocation: { lat: 34.05, lon: -118.24 },

    // UI & Sync State
    isSnapped: false,
    isMuted: false,
    showModal: false,
    ui: {
      activeTab: 'general',
      expandedPanel: null, // Track the ID of the open expansion panel here
    },

    // Chase Mode & Logic Tuning
    chaseMode: false,
    sampleSize: 20,
    resetTime: 30, // minutes
    sensitivity: 5,

    // LIVE STATE (Data shared with the app)
    currentStorm: {
      distance: 0,
      bearing: 0,
      trend: 'Stationary',
      frequency: 0,
    },

    // Buffer
    history: [],
    lastStrikeTimestamp: 0,

    // System/Backend Config
    authKey: null,
    wssServers: [8, 7, 2, 1],
    currentServerIndex: 0,
    calculationMethods: ['Closest Strike (Fastest)', 'Average (Smoother)', 'Percentile (Balanced)'],
    selectedMethod: 'Closest Strike (Fastest)',
  },

  // WEATHER CONFIGURATION
  weather: {
    tempUnit: 'fahrenheit',
    windUnit: 'mph',
    updateInterval: 300000, // 5 minutes,
    pressureUnit: 'inch',
    distanceUnit: 'mi',

    // Live Data placeholders (Optional: keeping these here if you want App.vue to see them)
    current: {
      temp: 0,
      feelsLike: 0,
      humidity: 0,
      windSpeed: 0,
      windDir: '',
      gusts: 0,
      pressure: 0,
      clouds: 0,
      visibility: 0,
      uv: 0,
      high: 0,
      low: 0,
      conditionText: '',
      dewPoint: 0,
    },
    alert: null,
    forecast: [],
  },

  // GLOBAL UI
  ui: {
    theme: 'dark',
    showAttribution: true,
    activeTab: 0, // for the main dashboard tabs
    panel: null,
    appName: 'Dashboard',
  },
})

let initialState = defaultSettings

// 3. THE HYDRATION (Check the "Disk")
const saved = localStorage.getItem('station_config_v1')
if (saved) {
  try {
    const parsed = JSON.parse(saved)

    // Specially merge the sub-objects to ensure nested properties (lat/lon) stick
    initialState.lightning = { ...defaultSettings.lightning, ...parsed.lightning }
    initialState.weather = { ...defaultSettings.weather, ...parsed.weather }
    initialState.ui = { ...defaultSettings.ui, ...parsed.ui }

    console.log('System Config Deep-Hydrated:', initialState.lightning.homeLocation)
  } catch (e) {
    console.error('Hydration failed', e)
  }
}

// ... existing reactive settings object ...
export const settings = reactive(initialState)
