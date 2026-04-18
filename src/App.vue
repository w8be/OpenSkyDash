<template>
  <v-app theme="dark">
    <v-main class="d-flex align-center justify-center bg-grey-darken-5 rounded-lg">
      <v-card width="300" class="mx-auto border-sm" elevation="24">

        <v-tabs v-model="activeTab" bg-color="#1a1a1a" color="grey-darken-1" grow density="compact">
          <v-tab value="weather">☁️</v-tab>
          <v-tab value="lightning">⚡</v-tab>
          <v-tab value="solar">☀️</v-tab>
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
import LightningCard from './components/cards/LightningCard.vue';
import SolarCard from './components/cards/SolarCard.vue';
import WeatherCard from './components/cards/WeatherCard.vue';

export default {
  // 2. Register components
  components: {
    LightningCard,
    SolarCard,
    WeatherCard
  },
  data() {
    return {
      activeTab: 0,
      // Ensure 'state' exists if your cards rely on it
      state: {
        currentStorm: {},
        solarData: {},
        weatherData: {}
      }
    };
  }
};
</script>