<template>
  <!-- <pre>Local: {{ shared.lightning.frequency }}</pre> 
  <v-btn @click="shared.lightning.frequency++">Manual Bump</v-btn> -->
  <v-app theme="dark">
    <v-app-bar color="#1e3838" density="compact">
      <v-app-bar-title>Station-Dashboard</v-app-bar-title>
      <v-spacer></v-spacer>
      <div class="pa-4 text-h6">{{ currentTime }}</div>
    </v-app-bar>
    <v-main class="d-flex align-start justify-center bg-grey-darken-5 rounded-lg mt-6">
      <v-card width="300" class="mx-auto border-sm" elevation="24">

        <v-tabs v-model="activeTab" bg-color="#1a1a1a" color="grey-darken-1" grow density="compact">
          <v-tab value="weather"><v-icon icon="mdi-weather-cloudy" color="blue" size="small" class="mr-1">
            </v-icon></v-tab>
          <v-tab value="lightning"><v-icon icon="mdi-flash" color="amber" size="small" class="mr-1"
              :class="{ 'pulsing-icon': (shared.lightning.frequency > 0) }">
            </v-icon></v-tab>
          <v-tab value="solar"><v-icon icon="mdi-white-balance-sunny" color="error" size="small" class="mr-1">
            </v-icon></v-tab>
        </v-tabs>

        <v-divider></v-divider>

        <v-window v-model="activeTab">

          <v-window-item value="weather" class="pa-4 text-center">
            <WeatherCard />
          </v-window-item>
          <v-window-item value="lightning">
            <LightningCard />
          </v-window-item>
          <v-window-item value="solar" class="pa-4 text-center">
            <SolarCard />
          </v-window-item>

        </v-window>
      </v-card>
    </v-main>
  </v-app>
</template>

<script>
// 1. Import .vue files
import { globalState } from './state.js';
import LightningCard from './components/cards/LightningCard.vue';
import SolarCard from './components/cards/SolarCard.vue';
import WeatherCard from './components/cards/WeatherCard.vue';

export default {
  components: {
    LightningCard,
    SolarCard,
    WeatherCard
  },
  data() {
    return {
      activeTab: 'lightning',
      // Look at the window object directly
      shared: window.G_STATE || globalState,
      currentTime: ''
    };
  },
  mounted() {
    this.updateClock();
    setInterval(this.updateClock, 1000);
  },
  methods: {
    updateClock() {
      this.currentTime = new Date().toLocaleTimeString();
    }
  }
};
</script>

<style scoped>
.pulsing-icon {
  animation: flash 1.5s infinite ease-in-out;
}

@keyframes flash {
  0% {
    opacity: 1;
  }

  50% {
    opacity: 0.4;
  }

  100% {
    opacity: 1;
  }
}
</style>