<template>
    <!-- 
    <pre>Vcals: {{ stg.units.distance.toLowerCase() }}</pre> -->
    <v-sheet value="weather" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <div v-if="stg.weather.current">

            <div v-if="stg.weather.current && stg.weather.current.temp !== undefined"
                class="d-flex justify-space-between align-start header-bg px-3 py-2 mt-2"
                style="position: relative; z-index: 10;">

                <div class="d-flex align-start ga-2">
                    <!-- The Icon -->
                    <v-icon :icon="stg.weather.current.icon || 'mdi-weather-cloudy'" color="blue-lighten-3"
                        size="x-large" class="mt-n1"></v-icon>

                    <!-- Wrap both lines in a column div to stack them -->
                    <div class="d-flex flex-column">
                        <!-- Top Line: Condition -->
                        <span class="text-subtitle-1 font-weight-bold text-brown-lighten-4"
                            style="font-size: 1.2rem; line-height: 1.1;">
                            {{ stg.weather.current.conditionText }}
                        </span>

                        <!-- Bottom Line: Attribution -->
                        <span class="text-grey-darken-1" style="font-size: 0.55rem; line-height: 1;">
                            Open-Meteo.com {{ stg.weather.current.lastUpdate }}
                        </span>
                    </div>
                </div>

                <div class="font-weight-bold text-brown-lighten-4"
                    style="font-size: 2.0rem; line-height: 1; margin-top: -1px;">
                    {{ Math.round(stg.weather.current.temp) }}°{{ stg.units.temperature.toUpperCase() }}
                </div>

            </div>

            <div v-else class="text-center py-4">
                <v-progress-circular indeterminate color="primary"></v-progress-circular>
            </div>

            <div class="d-flex justify-center ga-4 mb-4 text-caption text-grey-lighten-1">
                <span>Feels like {{ Math.round(stg.weather.current.feelsLike) }}°</span>
                <span class="text-orange-lighten-2">▲{{ Math.round(stg.weather.current.high) }}°</span>
                <span class="text-blue-lighten-2">▼{{ Math.round(stg.weather.current.low) }}°</span>
            </div>



            <div class=" metrics-grid border-t border-white-op ml-7">
                <div class="metric-cell border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-weather-windy-variant" v-tooltip:top="'Current Wind'"
                            color="blue-lighten-3" size="large"></v-icon></span>
                    <span class="val mr-2">{{ stg.weather.current.windDir }} <strong>{{ stg.weather.current.windSpeed }}
                            {{ stg.units.distance === 'Mi' ? 'mph' : 'km' }}</strong></span>
                </div>
                <div class="metric-cell">
                    <span class="label"><v-icon icon="mdi-water" v-tooltip:top="'Current Humidity'"
                            color="cyan-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.humidity }}%</strong></span>
                </div>

                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-windsock" v-tooltip:top="'Current Gusts'"
                            color="teal-lighten-1" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.gusts }} {{
                        stg.units.distance === 'Mi' ? 'mph' : 'km' }}</strong></span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-water-thermometer" v-tooltip:top="'Current Dew Point'"
                            color="cyan-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ Math.round(stg.weather.current.dewPoint) }}°{{
                        stg.units.temperature.toUpperCase() }}</strong></span>
                </div>
                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-gauge" v-tooltip:top="'Current Air Pressure'"
                            color="green-accent-4" size="large"></v-icon></span>
                    <span class="val"><strong>{{ localPressure }}</strong> {{ stg.units.pressure
                        === 'inch' ? 'in' : 'mb' }}</span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-clouds" v-tooltip:top="'Current Cloud Cover'"
                            color="indigo-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.clouds }}%</strong></span>
                </div>

                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-eye" v-tooltip:top="'Current Visibility'"
                            color="brown-lighten-2" size="large"></v-icon></span>
                    <span class="val"><strong>{{ localVisability }} {{ stg.units.distance
                            }}</strong></span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-sun-wireless" v-tooltip:top="'Current UV Exposure'"
                            color="amber-lighten-4" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.uv }} UV</strong></span>
                </div>
            </div>

            <v-expansion-panels v-model="panel" variant="accordion">
                <v-expansion-panel value="forecast" bg-color="grey-darken-4" class="rounded-0">
                    <v-expansion-panel-title
                        class=" text-capitalize text-caption font-weight-bold text-brown-lighten-4">
                        Forecast
                    </v-expansion-panel-title>
                    <v-expansion-panel-text class="forecast-body">
                        <div v-for="day in stg.weather.forecast" :key="day.name" class="forecast-row">
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
    props: {
        stg: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            //     stg: settings,
            shared: window.G_STATE,
            panel: null,
            currentServerIndex: 0,
            alert: null,
            forecast: [],
            previousApiTime: null,
            localPressure: 0,
            localVisability: 0
        };
    },
    mounted() {
        // clean up
        if (this.stg.weather.updateInterval) { clearInterval(this.stg.weather.updateInterval); }

        // Load

        const saved = localStorage.getItem('station_config_v1');
        if (saved && saved !== "undefined") {
            try {
                const config = JSON.parse(saved);
                // Apply your config logic here...
            } catch (e) {
                console.error("Weather Fetch failed:", error.message);
                // Optional: clear the bad data so it doesn't crash next time
                // localStorage.removeItem('station_config_v1');
            }
        } else {
            console.log("No saved config found. Loading defaults.");
        }
        // init
        this.fetchWeather();

        // schedule 
        if (this.stg.weather.updateInterval) clearInterval(this.stg.weather.updateInterval);

        const initialDelay = Math.random() * 15000;

        setTimeout(() => {
            // 3. NOW start the consistent 5-minute heartbeat
            this.fetchWeather(); // Run once immediately

            this.stg.weather.updateInterval = setInterval(() => {
                console.log("Heartbeat: Refreshing weather data...");
                this.fetchWeather();
            }, 300000); // Back to a rock-solid 5 minutes (300,000ms)

        }, initialDelay);
    },

    beforeUnmount() {
        // Clean up the timer when the component is destroyed
        if (this.stg.weather.updateInterval) {
            clearInterval(this.stg.weather.updateInterval);
        }
    },

    watch: {
        // Only re-fetch if the location actually changes
        'stg.units': {
            handler(newVal) {
                //  console.log("Units updated in prop:", newVal);
                this.fetchWeather();
            },
            deep: true
        },
        'stg.lightning.homeLocation': {
            handler() {
                this.fetchWeather();
            },
            deep: true
        }
    },

    methods: {

        debouncedRefresh() {
            clearTimeout(this.refreshTimer);
            this.refreshTimer = setTimeout(() => {
                //   console.log("Environment stabilized. Re-fetching Weather...");
                this.fetchWeather();
            }, 1000); // Increased to 1s to be extra safe during high-strike bursts
        },

        async fetchWeather() {
            const lat = this.stg.lightning.homeLocation.lat;
            const lon = this.stg.lightning.homeLocation.lon;
            const tUnit = this.stg.units.temperature.toLowerCase() === 'c' ? 'celsius' : 'fahrenheit';
            const pUnit = this.stg.units.pressure.toLowerCase() === 'in' ? 'inch' : 'hpa';
            const wUnit = this.stg.units.distance.toLowerCase() === 'mi' ? 'mph' : 'kmh';


            const params = [
                `latitude=${lat}`,
                `longitude=${lon}`,
                `cell_selection=nearest`,
                `current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,wind_gusts_10m,cloud_cover,visibility,dew_point_2m,uv_index`,
                `daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max`,
                `temperature_unit=${tUnit}`,
                `wind_speed_unit=${wUnit}`,
                `precipitation_unit=inch`,
                `pressure_unit=${pUnit}`,
                `timezone=auto`
            ].join('&');

            const url = `https://api.open-meteo.com/v1/forecast?${params}`;

            //  console.log("DEBUG: pUnit is:", pUnit);
            console.log("Fetching Weather Data from:", url);

            try {
                const response = await fetch(url);
                const data = await response.json();
                if (data.error || !data.current) {
                    console.error("Open-Meteo Error:", data.reason || "Malformed response");
                    return;
                }

                // 1. Process Condition
                const condition = this.interpretWMO(data.current.weather_code);
                this.stg.weather.current.conditionText = condition.text;
                this.shared.weather.icon = condition.icon;

                const apiUnit = data.current_units.visibility; // 'ft' or 'm'
                const rawVisibility = data.current.visibility;
                let vCalc = 0;

                if (this.stg.units.distance.toLowerCase() === 'mi') {
                    vCalc = (apiUnit === 'ft') ? (rawVisibility / 5280) : (rawVisibility / 1609.34);
                } else {
                    vCalc = (apiUnit === 'ft') ? (rawVisibility / 3280.84) : (rawVisibility / 1000);
                }

                this.localVisability = Math.round(vCalc * 100) / 100;


                let rawPressure = data.current.pressure_msl;
                const pressureApiUnit = data.current_units.pressure_msl.toLowerCase(); // Ensure lowercase

                const calculatedPressure = (this.stg.units.pressure.toLowerCase() === 'inch' && pressureApiUnit === 'hpa')
                    ? (rawPressure * 0.02953).toFixed(2)
                    : rawPressure.toFixed(1);
                // console.log(calculatedPressure);
                this.localPressure = calculatedPressure;
                // Reassign the object using the spread operator to trigger Vue reactivity
                this.stg.weather.current = {
                    ...this.stg.weather.current,
                    pressure: calculatedPressure,
                };

                //  console.log(`DEBUG: User wants: ${this.stg.units.pressure} | API sent: ${pressureApiUnit}`);
                // Add lastUpdated time
                // 1. Get the data from the API
                const apiTime = data.current.time; // e.g., "2026-04-24T12:00"

                // 2. The Gatekeeper: Check if the weather is ACTUALLY new
                if (apiTime !== this.previousApiTime) {

                    // Update our "memory" of the last time the weather changed
                    this.previousApiTime = apiTime;

                    // 3. Formatting: Create the pretty string for the UI
                    const date = new Date(); // The time "Now"
                    this.stg.weather.current.lastUpdate = date.toLocaleString('en-US', {
                        hour12: true,
                        hour: 'numeric',
                        minute: 'numeric'
                    });

                    console.log("Weather data changed! Updating timestamp.");
                } else {
                    console.log("Weather API returned same data. Keeping old timestamp.");
                }


                // 2. Map Current Weather
                // Note: Using pressure_msl (Mean Sea Level) for your 'Pres' display
                this.stg.weather.current = {
                    ...this.stg.weather.current, // Keep existing structure
                    temp: Math.round(data.current.temperature_2m),
                    visibility: vCalc.toFixed(1), // Apply formatting here
                    pressure: rawPressure,
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
                this.stg.weather.forecast = data.daily.time.slice(0, 3).map((date, i) => {
                    const dayCond = this.interpretWMO(data.daily.weather_code[i]);
                    return {
                        name: i === 0 ? 'Today' : new Date(date + 'T00:00:00').toLocaleDateString('en-US', { weekday: 'short' }),
                        high: Math.round(data.daily.temperature_2m_max[i]),
                        low: Math.round(data.daily.temperature_2m_min[i]),
                        precip: data.daily.precipitation_probability_max[i],
                        icon: dayCond.icon
                    };
                });

                this.shared.weatherIcon = condition.icon;
                this.stg.weather.icon = condition.icon;

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
    /* Keep your columns */
}

.metric-cell {
    display: flex;
    /* Turn on flexbox */
    align-items: center;
    /* Vertically center icon and text */
    justify-content: flex-start;
    /* Push everything to the left */
    padding: 4px 8px;
    /* Add some internal breathing room */
    gap: 8px;
    /* This is the MAGIC: fixed gap between icon and value */
}

.metric-cell .label {
    display: flex;
    min-width: 40px;
    /* Ensures icons line up vertically regardless of width */
    justify-content: center;
}


.val {
    font-size: 0.80rem;
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
    width: 60px;
    text-align: right;
}

/* Removes default Vuetify expansion panel rounded corners for flush look */
.v-expansion-panel {
    border-radius: 0 !important;
}
</style>