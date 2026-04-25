<template>
  <!--<v-btn @click="shared.lightning.frequency++">Manual Bump</v-btn> -->

  <v-app theme="dark">
    <pre>shared.weather.icon: {{ shared.weather.icon }} </pre>
    <v-app-bar color="#1e3838" density="compact">
      <v-app-bar-title class="text-brown-lighten-4"><v-icon icon="mdi-monitor-dashboard" color="brown-lighten-4"
          size="small"></v-icon> {{ stg.ui.appName }}</v-app-bar-title>
      <v-spacer></v-spacer>
      <div class="pa-4 text-h6 text-brown-lighten-4">{{ currentTime }}</div>
    </v-app-bar>
    <v-main class="d-flex align-start justify-center bg-grey-darken-5 rounded-lg mt-4">
      <v-card minwidth="300" maxwidth="300" class="mx-auto border-sm" elevation="24">

        <v-tabs v-model="activeTab" bg-color="#1a1a1a" color="grey-darken-1" grow density="compact">
          <v-tab value="weather">
            <v-icon :icon="shared.weather.icon" color="blue" size="small" class="mr-1"></v-icon>
          </v-tab>
          <v-tab value="lightning"><v-icon icon="mdi-flash" color="amber" size="small" class="mr-1"
              :class="{ 'pulsing-icon': (shared.lightning.frequency > 0) }">
            </v-icon></v-tab>
          <v-tab value="solar"><v-icon icon="mdi-white-balance-sunny" color="error" size="small" class="mr-1">
            </v-icon></v-tab>
          <v-tab value="settings"><v-icon icon="mdi-cog" color="grey" size="small">
            </v-icon></v-tab>
        </v-tabs>

        <v-divider></v-divider>

        <v-window v-model="activeTab">

          <v-window-item value="weather">
            <WeatherCard />
          </v-window-item>
          <v-window-item value="lightning">
            <LightningCard />
          </v-window-item>
          <v-window-item value="solar">
            <SolarCard />
          </v-window-item>
          <v-window-item value="settings">
            <SettingsCard />
          </v-window-item>

        </v-window>
      </v-card>
    </v-main>
  </v-app>
</template>

<script>
// 1. Import your existing state and the NEW dashboard settings
import { globalState } from './state.js';
import { settings } from './components/cards/dashboardSettings.js'; // Import the new master file

// 2. Import .vue files
import LightningCard from './components/cards/LightningCard.vue';
import SolarCard from './components/cards/SolarCard.vue';
import WeatherCard from './components/cards/WeatherCard.vue';
import SettingsCard from './components/cards/SettingsCard.vue';

export default {
  components: {
    LightningCard,
    SolarCard,
    WeatherCard,
    SettingsCard
  },
  data() {
    return {
      // MASTER SETTINGS LINK
      stg: settings,

      activeTab: 'lightning',
      shared: window.G_STATE || globalState,
      currentTime: '',

    };
  },
  mounted() {
    this.updateClock();
    setInterval(this.updateClock, 1000);
  },
  methods: {
    updateClock() {
      this.currentTime = new Date().toLocaleTimeString();
    },
    // Add a helper to open the settings
    openSettings() {
      this.stg.lightning.showModal = true;
    }
  }
};
</script>

<style scoped>
.border-white-op {
  border-color: rgba(255, 255, 255, 0.1) !important;
}

/* Grid Layout: Adds breathing room compared to previous condensed version */
.metrics-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  width: 100%;
}

.metric-cell {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 14px;
  /* Increased padding for better legibility */
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.metric-cell:nth-child(odd) {
  border-right: 1px solid rgba(255, 255, 255, 0.1);
}

.label {
  color: #94a3b8;
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
}

.val {
  font-size: 0.85rem;
  color: #f8fafc;
  font-weight: 600;
}

/* Forecast Scaling: Shrinks text to prevent the "bulky" look */
.forecast-body :deep(.v-expansion-panel-text__wrapper) {
  padding: 8px 12px !important;
}

.forecast-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  font-size: 0.75rem;
  /* Reduced from default */
}

.day-label {
  width: 35px;
  font-weight: 600;
}

.temp-range {
  flex-grow: 1;
  text-align: center;
  font-family: monospace;
}

.precip {
  width: 45px;
  text-align: right;
}

.custom-tabs {
  max-width: 300px;
}

.v-tab {
  min-width: 0;
  /* Allows tab to shrink below 90px */
  padding: 0 4px;
  /* Reduces horizontal padding */
}
</style>