<template>

    <!-- <pre>weather.distanceUnit: {{ stg.weather.distanceUnit }}</pre> -->
    <v-sheet value="weather" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <div v-if="weather.current">

            <div v-if="weather.current && weather.current.temp !== undefined"
                class="d-flex justify-space-between align-start header-bg px-3 py-2 mt-2"
                style="position: relative; z-index: 10;">

                <div class="d-flex flex-column">
                    <div class="d-flex align-start ga-2">
                        <v-icon :icon="weather.current.icon || 'mdi-weather-cloudy'" color="blue-lighten-3"
                            size="x-large" class="mt-n1"></v-icon>

                        <span class="font-weight-bold text-brown-lighten-4" style="font-size: 2.0rem; line-height: 1;">
                            {{ Math.round(weather.current.temp) }}°{{ stg.weather.tempUnit === 'fahrenheit' ? 'F' : 'C'
                            }}
                        </span>
                    </div>

                    <span class="text-grey-darken-1 mt-n1" style="font-size: 0.55rem; padding-left: 2px;">
                        Open-Meteo.com
                    </span>
                </div>

                <div class="font-weight-bold text-brown-lighten-4"
                    style="font-size: 1.5rem; line-height: 1; margin-top: -1px;">
                    {{ weather.current.conditionText }}
                </div>
            </div>

            <div v-else class="text-center py-4">
                <v-progress-circular indeterminate color="primary"></v-progress-circular>
            </div>

            <div class="d-flex justify-center ga-4 mb-4 text-caption text-grey-lighten-1">
                <span>Feels like {{ Math.round(weather.current.feelsLike) }}°</span>
                <span class="text-orange-lighten-2">▲{{ Math.round(weather.current.high) }}°</span>
                <span class="text-blue-lighten-2">▼{{ Math.round(weather.current.low) }}°</span>
            </div>



            <div class=" metrics-grid border-t border-white-op">
                <div class="metric-cell border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-weather-windy-variant" color="blue-lighten-3"
                            size="large"></v-icon></span>
                    <span class="val">{{ weather.current.windDir }} <strong>{{ weather.current.windSpeed }} {{
                        stg.weather.distanceUnit === 'Mi' ? 'mph' : 'km' }}</strong></span>
                </div>
                <div class="metric-cell">
                    <span class="label"><v-icon icon="mdi-water" color="blue-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ weather.current.humidity }}%</strong></span>
                </div>

                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-windsock" color="blue-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ weather.current.gusts }} {{
                        stg.weather.distanceUnit === 'Mi' ? 'mph' : 'km' }}</strong></span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-water-thermometer" color="blue-lighten-3"
                            size="large"></v-icon></span>
                    <span class="val"><strong>{{ Math.round(weather.current.dewPoint) }}° {{ stg.weather.tempUnit ===
                        'fahrenheit' ? 'F' : 'C'
                            }}</strong></span>
                </div>

                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-gauge" color="blue-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ weather.current.pressure }}</strong> {{ stg.weather.pressureUnit ===
                        'inch' ? 'in' : 'mb' }}</span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-clouds" color="blue-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ weather.current.clouds }}%</strong></span>
                </div>

                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-eye" color="blue-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ weather.current.visibility }} {{ stg.weather.distanceUnit
                            }}</strong></span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-sun-wireless" color="blue-lighten-3"
                            size="large"></v-icon></span>
                    <span class="val"><strong>{{ weather.current.uv }} UV</strong></span>
                </div>
            </div>

            <v-expansion-panels v-model="panel" variant="accordion">
                <v-expansion-panel value="forecast" bg-color="grey-darken-4" class="rounded-0">
                    <v-expansion-panel-title
                        class=" text-capitalize text-caption font-weight-bold text-brown-lighten-4 py-2">
                        Forecast
                    </v-expansion-panel-title>
                    <v-expansion-panel-text class="forecast-body">
                        <div v-for="day in weather.forecast" :key="day.name" class="forecast-row">
                            <span class="day-label mr-2">{{ day.name }}</span>
                            <v-icon :icon="day.icon" size="small" color="blue-lighten-4"></v-icon>
                            <span class="temp-range">{{ Math.round(day.high) }}°/{{ Math.round(day.low) }}°</span>
                            <span class="precip text-blue-lighten-4">💧{{ day.precip }}%</span>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </div>

        <v-container v-else class="d-flex justify-center align-center" style="height: 400px;">
            <v-progress-circular indeterminate color="blue-lighten-3"></v-progress-circular>
        </v-container>
    </v-sheet>
</template>

<script>
import { settings } from './dashboardSettings.js';
export default {
    name: 'WeatherCard',

    data() {
        return {
            stg: settings,
            panel: null, // Removed the duplicate
            currentServerIndex: 0,
            weather: {
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
                    conditionText: 'Loading...', // Give it a string so the DOM doesn't flicker empty
                    dewPoint: 0
                },
                alert: null,
                forecast: []
            }
        };
    },
    mounted() {
        this.fetchWeather(); // Run immediately on load

        // Set a 10-minute heartbeat (600,000 ms)
        this.weatherTimer = setInterval(() => {
            console.log("Heartbeat: Refreshing weather data...");
            this.fetchWeather();
        }, 600000);
    },
    beforeUnmount() {
        // Clean up the timer when the component is destroyed
        if (this.weatherTimer) {
            clearInterval(this.weatherTimer);
        }
    },

    watch: {
        // Watch settings (Units, etc.)
        'stg.weather': {
            handler() {
                this.debouncedRefresh();
            },
            deep: true
        },
        // Watch location (Lat/Lon) - removed 'this.' and added to debounce
        'stg.lightning.homeLocation.lat': {
            handler() { this.debouncedRefresh(); }
        },
        'stg.lightning.homeLocation.lon': {
            handler() { this.debouncedRefresh(); }
        }
    },

    methods: {

        debouncedRefresh() {
            clearTimeout(this.refreshTimer);
            this.refreshTimer = setTimeout(() => {
                console.log("Environment stabilized. Re-fetching Weather...");
                this.fetchWeather();
            }, 1000); // Increased to 1s to be extra safe during high-strike bursts
        },

        async fetchWeather() {
            const lat = this.stg.lightning.homeLocation.lat;
            const lon = this.stg.lightning.homeLocation.lon;
            const tUnit = this.stg.weather.tempUnit === 'celsius' ? 'celsius' : 'fahrenheit';
            const pUnit = this.stg.weather.pressureUnit === 'inch' ? 'imperial' : 'hpa';
            const dUnit = this.stg.weather.distanceUnit;


            const params = [
                `latitude=${lat}`,
                `longitude=${lon}`,
                // Add uv_index here
                `current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,wind_gusts_10m,cloud_cover,visibility,dew_point_2m,uv_index`,
                `daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max`,
                `temperature_unit=${tUnit}`,
                `wind_speed_unit=${this.stg.weather.distanceUnit === 'mi' ? 'mph' : 'kmh'}`,
                `precipitation_unit=inch`,
                `pressure_unit=${pUnit}`,
                `timezone=auto`
            ].join('&');

            const url = `https://api.open-meteo.com/v1/forecast?${params}`;

            console.log("DEBUG: pUnit is:", pUnit);
            console.log("DEBUG: URL is:", url);

            try {
                const response = await fetch(url);
                const data = await response.json();

                // CHECKPOINT: If the API returned an error, stop here!
                if (data.error || !data.current) {
                    console.error("Open-Meteo Error:", data.reason || "Malformed response");
                    return;
                }

                // 1. Process Condition
                const condition = this.interpretWMO(data.current.weather_code);
                const apiUnit = data.current_units.visibility; // 'ft' or 'm'
                const rawVisibility = data.current.visibility;
                let vCalc = 0;

                if (this.stg.weather.distanceUnit === 'mi') {
                    vCalc = (apiUnit === 'ft') ? (rawVisibility / 5280) : (rawVisibility / 1609.34);
                } else {
                    vCalc = (apiUnit === 'ft') ? (rawVisibility / 3280.84) : (rawVisibility / 1000);
                }

                let pressureVal = data.current.pressure_msl;
                const apiPressureUnit = data.current_units.pressure_msl; // e.g., "hPa"

                // 2. The Logic Gate: If we want 'inch' but got 'hPa', do the math
                if (this.stg.weather.pressureUnit === 'inch' && apiPressureUnit === 'hPa') {
                    // 1016.2 * 0.02953 = 30.01
                    pressureVal = (pressureVal * 0.02953).toFixed(2);
                } else {
                    // If units already match, just handle the decimal rounding
                    pressureVal = pressureVal.toFixed(this.stg.weather.pressureUnit === 'inch' ? 2 : 1);
                }

                // 2. Map Current Weather
                // Note: Using pressure_msl (Mean Sea Level) for your 'Pres' display
                this.weather.current = {
                    ...this.weather.current, // Keep existing structure
                    temp: Math.round(data.current.temperature_2m),
                    visibility: vCalc.toFixed(1), // Apply formatting here
                    pressure: pressureVal,
                    feelsLike: Math.round(data.current.apparent_temperature),
                    humidity: data.current.relative_humidity_2m,
                    windSpeed: Math.round(data.current.wind_speed_10m),
                    windDir: this.getWindDir(data.current.wind_direction_10m),
                    gusts: Math.round(data.current.wind_gusts_10m),
                    clouds: data.current.cloud_cover,
                    uv: data.current.uv_index,
                    high: Math.round(data.daily.temperature_2m_max[0]),
                    low: Math.round(data.daily.temperature_2m_min[0]),
                    dewPoint: Math.round(data.current.dew_point_2m),
                    conditionText: condition.text,
                    icon: condition.icon
                };

                // 3. Map Forecast Array
                this.weather.forecast = data.daily.time.slice(0, 3).map((date, i) => {
                    const dayCond = this.interpretWMO(data.daily.weather_code[i]);
                    return {
                        name: i === 0 ? 'Today' : new Date(date + 'T00:00:00').toLocaleDateString('en-US', { weekday: 'short' }),
                        high: Math.round(data.daily.temperature_2m_max[i]),
                        low: Math.round(data.daily.temperature_2m_min[i]),
                        precip: data.daily.precipitation_probability_max[i],
                        icon: dayCond.icon
                    };
                });

                this.loading = false;

            } catch (error) {
                console.error("Network or Parsing failure:", error);
                this.loading = false;
            }
        },
        getWindDir(deg) {
            const sectors = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
            return sectors[Math.round(deg / 45) % 8];
        },
        interpretWMO(code) {
            // Returns an object with both text and a Vuetify-friendly MDI icon
            if (code === 0) return { text: 'Clear', icon: 'mdi-weather-sunny' };
            if (code <= 3) return { text: 'Partly Cloudy', icon: 'mdi-weather-partly-cloudy' };
            if (code >= 45 && code <= 48) return { text: 'Foggy', icon: 'mdi-weather-fog' };
            if (code >= 51 && code <= 67) return { text: 'Rainy', icon: 'mdi-weather-rainy' };
            if (code >= 71 && code <= 77) return { text: 'Snowy', icon: 'mdi-weather-snowy' };
            if (code >= 95) return { text: 'Stormy', icon: 'mdi-weather-lightning' };
            return { text: 'Overcast', icon: 'mdi-weather-cloudy' };
        }
    },
    // Inside WeatherCard.vue
};
</script>

<style scoped>
.border-white-op {
    border-color: rgba(255, 255, 255, 0.1) !important;
}

/* Decompressed Grid: 10px padding for breathing room */
.metrics-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    width: 100%;
}

.metric-cell {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 12px;
}

.label {
    color: #94a3b8;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: text-capitalize;
}

.val {
    font-size: 0.85rem;
    color: #D7CCC8;
    font-weight: 600;
    font-family: 'Roboto Mono', monospace;
}

/* Forecast Scaling: Shrinks text to fix bulkiness */
.forecast-body :deep(.v-expansion-panel-text__wrapper) {
    padding: 8px 12px !important;
}

.forecast-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    font-size: 1.0rem;
}

.day-label {
    color: #D7CCC8;
    width: 45px;
    font-weight: 700;
    font-family: 'Roboto Mono', monospace;
}

.temp-range {
    flex-grow: 1;
    text-align: center;
    font-family: 'Roboto Mono', monospace;
    font-weight: 500;
}

.precip {
    width: 45px;
    text-align: right;
}

/* Removes default Vuetify expansion panel rounded corners for flush look */
.v-expansion-panel {
    border-radius: 0 !important;
}
</style>