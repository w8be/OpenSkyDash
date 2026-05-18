<template>
  <v-app>
    <v-app-bar color="#1e3838" density="compact">
      <v-app-bar-title class="text-brown-lighten-4"><v-icon icon="mdi-monitor-dashboard" color="primary"
          size="small"></v-icon> {{ stg?.ui?.appName || 'SkyDash' }}</v-app-bar-title>
      <v-spacer></v-spacer>
      <div class="pa-4 text-h6 text-brown-lighten-4">{{ currentTime }}</div>
    </v-app-bar>

    <v-main class="d-flex align-start justify-center bg-grey-darken-5 rounded-lg mt-4">
      <v-card minwidth="300" maxwidth="300" class="mx-auto border-sm" elevation="24">

        <v-tabs v-model="stg.ui.activeTab" bg-color="#1a1a1a" color="grey-darken-1" grow density="compact">
          <v-tab value="weather">
            <template v-slot:prepend>
              <v-icon :icon="shared.weather.icon" color="blue" size="small" class="mr-1"></v-icon>
            </template>
          </v-tab>
          <v-tab value="lightning"><v-icon icon="mdi-flash" color="amber" size="small" class="mr-1"
              :class="{ 'pulsing-icon': (shared.lightning.frequency > 0) }">
            </v-icon></v-tab>
          <v-tab value="solar"><v-icon icon="mdi-sun-wireless" color="error" size="small" class="mr-1"
              :class="{ 'pulsing-icon': (shared.solar.current.scales.current.g > 0 || shared.solar.current.scales.current.r > 0 || shared.solar.current.scales.current.s > 0) }">
            </v-icon></v-tab>
          <v-tab value="settings"><v-icon icon="mdi-cog" color="grey" size="small">
            </v-icon></v-tab>
        </v-tabs>
        <v-divider></v-divider>
        <v-window v-model="stg.ui.activeTab" :touch="false" :transition="false">
          <v-window-item value="weather" eager>
            <WeatherCard v-show="stg.ui.activeTab === 'weather'" :stg="stg" />
          </v-window-item>
          <v-window-item v-show="stg.ui.activeTab === 'lightning'" value="lightning" eager>
            <LightningCard :stg="stg" />
          </v-window-item>
          <v-window-item value="solar" eager>
            <SolarCard v-show="stg.ui.activeTab === 'solar'" :stg="stg" />
          </v-window-item>
          <v-window-item value="settings" eager>
            <SettingsCard v-if="stg.ui.activeTab === 'settings'" :stg="stg"
              @update-distance="(val) => stg.units.distance = val" />
          </v-window-item>
        </v-window>
      </v-card>
    </v-main>
  </v-app>
</template>

<script>
import { useTheme } from 'vuetify';
import { reactive } from 'vue';
import { defaultSettings as settings } from './components/cards/dashboardSettings.js';
import '@mdi/font/css/materialdesignicons.css';

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
  setup() {
    const theme = useTheme();
    return { theme };
  },
  data() {
    return {
      // 🟢 One single source of truth for configuration AND live telemetry
      stg: reactive(window.G_STATE || settings),
      activeTab: 'weather',
      currentTime: '',
    };
  },
  mounted() {
    const savedSettings = localStorage.getItem('station_config_v1');

    if (savedSettings) {
      try {
        const parsed = JSON.parse(savedSettings);

        // 🟢 1. Explicitly restore the nested station coordinates directly
        if (parsed.lightning && parsed.lightning.homeLocation) {
          this.stg.lightning.homeLocation.lat = parseFloat(parsed.lightning.homeLocation.lat);
          this.stg.lightning.homeLocation.lon = parseFloat(parsed.lightning.homeLocation.lon);
        }

        // 🟢 2. Explicitly restore any other nested settings you need (like UI app name)
        if (parsed.ui && parsed.ui.appName) {
          this.stg.ui.appName = parsed.ui.appName;
        }

        console.log("App.vue: Successfully locked in restored coordinates:", this.stg.lightning.homeLocation);
      } catch (e) {
        console.error("App.vue: Error parsing saved settings", e);
      }
    }

    this.updateClock();
    setInterval(this.updateClock, 1000);
  },

  methods: {
    updateClock() {
      this.currentTime = new Date().toLocaleTimeString();
    },
  }
};
</script>

<style scoped>
:root {
  --bg-color: #ffffff;
  --text-color: #000000;
}

html.dark {
  --bg-color: #1a1a1a;
  --text-color: #ffffff;
}

body {
  background-color: var(--bg-color);
  color: var(--text-color);
  transition: background-color 0.3s, color 0.3s;
}

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

.pulsing-icon {
  animation: pulse-lightning 1.5s infinite ease-in-out;
  display: inline-block;
}

@keyframes pulse-lightning {
  0% {
    transform: scale(1);
    filter: brightness(1) drop-shadow(0 0 0px rgba(255, 193, 7, 0));
  }

  50% {
    transform: scale(1.2);
    filter: brightness(1.8) drop-shadow(0 0 5px rgba(255, 193, 7, 0.8));
  }

  100% {
    transform: scale(1);
    filter: brightness(1) drop-shadow(0 0 0px rgba(255, 193, 7, 0));
  }
}
</style>