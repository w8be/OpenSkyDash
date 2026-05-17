<template>
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
                            {{ stg.units.distance === 'mi' ? 'mph' : 'km' }}</strong></span>
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
                        stg.units.distance === 'mi' ? 'mph' : 'km' }}</strong></span>
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
                    <span class="val"><strong>{{ stg.weather.current.pressure }}</strong> <small class="text-caption">{{
                        stg.units.pressure ===
                            'inch' ? 'in' : 'mb' }}</small></span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-clouds" v-tooltip:top="'Current Cloud Cover'"
                            color="indigo-lighten-3" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.clouds }}%</strong></span>
                </div>

                <div class="metric-cell border-t border-r border-white-op">
                    <span class="label"><v-icon icon="mdi-eye" v-tooltip:top="'Current Visibility'"
                            color="brown-lighten-2" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.visibility }} {{ stg.units.distance
                    }}</strong></span>
                </div>
                <div class="metric-cell border-t border-white-op">
                    <span class="label"><v-icon icon="mdi-sun-wireless" v-tooltip:top="'Current UV Exposure'"
                            color="amber-lighten-4" size="large"></v-icon></span>
                    <span class="val"><strong>{{ stg.weather.current.uv }} UV</strong></span>
                </div>
            </div>

            <div v-if="stg.weather.forecast.length > 0"
                class="forecast-container ml-2 mr-2 mt-2 border-t-sm border-grey-darken-3">
                <div class="pa-2 bg-grey-darken-4">
                    <div v-for="day in stg.weather.forecast" :key="day.name"
                        class="forecast-row d-flex align-center justify-space-between">
                        <span class="day-label text-caption" style="width: 50px">{{ day.name }}</span>
                        <v-icon :icon="day.icon" size="small" color="blue-lighten-4"></v-icon>
                        <span class="temp-range text-caption ml-4">{{ Math.round(day.high) }}°/{{ Math.round(day.low)
                        }}°</span>
                        <span class="precip text-caption text-blue-lighten-4" style="width: 80px; text-align: right;">
                            💧{{ day.precip }}%
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <v-container v-else class="d-flex justify-center align-center" style="height: 400px;">
            <v-progress-circular indeterminate color="blue-lighten-3"></v-progress-circular>
        </v-container>
    </v-sheet>
</template>

<script>
// import { settings } from './dashboardSettings.js';
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
            data: null,
            shared: window.G_STATE,
            alert: null,
            forecast: [],
            previousApiTime: null,
            localPressure: 0,
            localVisability: 0,
            localToggle: null
        };
    },
    mounted() {

        if (this.stg.weather.updateInterval) { clearInterval(this.stg.weather.updateInterval); }

        const saved = localStorage.getItem('station_config_v1');
        if (saved && saved !== "undefined") {
            try {
                const config = JSON.parse(saved);
                // Apply your config logic here...
            } catch (e) {
                console.error("Weather Fetch failed:", error.message);
            }
        } else {
            console.log("No saved config found. Loading defaults.");
        }

        this.fetchWeather();

        if (this.stg.weather.updateInterval) clearInterval(this.stg.weather.updateInterval);

        const initialDelay = Math.random() * 15000;

        setTimeout(() => {
            this.fetchWeather();

            this.stg.weather.updateInterval = setInterval(() => {
                console.log("Heartbeat: Refreshing weather data...");
                this.fetchWeather();
            }, 300000);
        }, initialDelay);
    },

    beforeUnmount() {
        if (this.stg.weather.updateInterval) {
            clearInterval(this.stg.weather.updateInterval);
        }
    },

    watch: {
        'stg.units': {
            handler(newVal) {
                this.fetchWeather();
            },
            deep: true
        },
        'stg.lightning.homeLocation': {
            handler() {
                this.fetchWeather();
            },
            deep: true
        },
        // 🟢 Only refetch if temperature toggles (C <=> F)
        'stg.units.temperature'() {
            console.log("WeatherCard: Temperature unit changed. Fetching fresh data...");
            this.fetchWeather();
        },

        // 🟢 Only refetch if pressure toggles (in <=> hPa)
        'stg.units.pressure'() {
            console.log("WeatherCard: Pressure unit changed. Fetching fresh data...");
            this.fetchWeather();
        },

        // 🟢 Only refetch if distance/speed toggles (mi <=> km)
        'stg.units.distance'() {
            console.log("WeatherCard: Distance/Wind unit changed. Fetching fresh data...");
            this.fetchWeather();
        }
    },

    methods: {

        debouncedRefresh() {
            clearTimeout(this.refreshTimer);
            this.refreshTimer = setTimeout(() => {
                this.fetchWeather();
            }, 1000);
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

            try {
                const response = await fetch(url);
                const data = await response.json();

                if (data.error || !data.current) {
                    console.error("Open-Meteo Error:", data.reason || "Malformed response");
                    return;
                }

                const condition = this.interpretWMO(data.current.weather_code);

                const apiUnit = data.current_units.visibility;
                const rawVisibility = data.current.visibility;
                let calculatedValue = (this.stg.units.distance.toLowerCase() === 'mi')
                    ? (apiUnit === 'ft' ? (rawVisibility / 5280) : (rawVisibility / 1609.34))
                    : (apiUnit === 'ft' ? (rawVisibility / 3280.84) : (rawVisibility / 1000));

                this.stg.weather.current.visibility = calculatedValue.toFixed(1);

                const rawPressure = data.current.pressure_msl;
                const pressureApiUnit = data.current_units.pressure_msl.toLowerCase();
                const finalPressure = (this.stg.units.pressure.toLowerCase() === 'inch' && pressureApiUnit === 'hpa')
                    ? (rawPressure * 0.02953).toFixed(2)
                    : rawPressure.toFixed(1);

                this.stg.weather.current.pressure = finalPressure;

                const apiTime = data.current.time;
                let lastUpdateString = this.stg.weather.current.lastUpdate;

                if (apiTime !== this.previousApiTime) {
                    this.previousApiTime = apiTime;
                    lastUpdateString = new Date().toLocaleString('en-US', {
                        hour12: true, hour: 'numeric', minute: 'numeric'
                    });
                }
                this.stg.weather.current = {
                    ...this.stg.weather.current,
                    temp: Math.round(data.current.temperature_2m),
                    visibility: this.stg.weather.current.visibility,
                    pressure: finalPressure,
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
                    icon: condition.icon,
                    lastUpdate: lastUpdateString
                };

                const forecastBuffer = data.daily.time.slice(0, 3).map((date, i) => {
                    const dayCond = this.interpretWMO(data.daily.weather_code[i]);
                    return {
                        name: i === 0 ? 'Today' : new Date(date + 'T00:00:00').toLocaleDateString('en-US', { weekday: 'short' }),
                        high: Math.round(data.daily.temperature_2m_max[i]),
                        low: Math.round(data.daily.temperature_2m_min[i]),
                        precip: data.daily.precipitation_probability_max[i],
                        icon: dayCond.icon
                    };
                });

                requestAnimationFrame(() => {
                    this.stg.weather.forecast = forecastBuffer;
                    this.shared.weatherIcon = condition.icon;
                    this.stg.weather.icon = condition.icon;
                    this.loading = false;
                });

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
            if (code === 0) return { text: 'Clear', icon: 'mdi-weather-sunny' };
            if (code <= 3) return { text: 'Partly Cloudy', icon: 'mdi-weather-partly-cloudy' };
            if (code >= 45 && code <= 48) return { text: 'Foggy', icon: 'mdi-weather-fog' };
            if (code >= 51 && code <= 67) return { text: 'Rainy', icon: 'mdi-weather-rainy' };
            if (code >= 71 && code <= 77) return { text: 'Snowy', icon: 'mdi-weather-snowy' };
            if (code >= 95) return { text: 'Stormy', icon: 'mdi-weather-lightning' };
            return { text: 'Overcast', icon: 'mdi-weather-cloudy' };
        }
    },
};
</script>

<style scoped>
.border-white-op {
    border-color: rgba(255, 255, 255, 0.1) !important;
}

.metrics-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
}

.metric-cell {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    padding: 4px 8px;
    gap: 8px;
}

.metric-cell .label {
    display: flex;
    min-width: 40px;
    justify-content: center;
}


.val {
    font-size: 0.80rem;
    color: #D7CCC8;
    font-weight: 600;
    font-family: 'Roboto Mono', monospace;
}

.forecast-body :deep(.v-expansion-panel-text__wrapper) {
    padding: 8px 12px !important;
}

.forecast-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2px 2px;
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
</style>