<template>

    <v-sheet value="solar" transition="fade-transition" flat class="solarCard mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10;">
            <div class="d-flex align-center">
                <v-icon icon="mdi-white-balance-sunny" color="error" size="large" </v-icon>
                    <div class="d-flex flex-column align-start ml-2">
                        <span class="text-subtitle-1 font-weight-bold stat-value"
                            style="line-height: 1.0rem; font-size: 1.2rem;">Solar</span>
                        <span class="text-grey-darken-1" style="font-size: 0.55rem;">NOAA.org / KC2G.com {{
                            stg.solar.current.ionosphere.timestamp }}</span>
                    </div>
            </div>
        </div>
        <div>
            <v-row justify="space-around" class="mt-1">
                <!-- SFI Gauge: Max 300 -->
                <v-col cols="4" class="text-center">
                    <v-progress-circular :model-value="Number(stg.solar.current.geoMagnetic.flux / 300) * 100"
                        :max="300" :size="60" :width="8" :color="getSFIColor(stg.solar.current.geoMagnetic.flux)"
                        bg-color="grey-darken-3" rotate="220">
                        <span class="text-h6 font-weight-bold">{{ stg.solar.current.geoMagnetic.flux
                            }}</span>
                    </v-progress-circular>
                    <div v-tooltip:bottom="'10.7cm'" class="text-subtitle-2 mt-1  stat-value">SFI</div>
                </v-col>

                <!-- A-Index Gauge: Max 100 -->
                <v-col cols="4" class="text-center">
                    <v-progress-circular :model-value="Number(stg.solar.current.geoMagnetic.aIndex)" :max="100"
                        :size="60" :width="8" :color="getAIndexColor(stg.solar.current.geoMagnetic.aIndex)"
                        bg-color="grey-darken-3" rotate="220">
                        <span class="text-h6 font-weight-bold">{{ stg.solar.current.geoMagnetic.aIndex }}</span>
                    </v-progress-circular>
                    <div class="text-subtitle-2 mt-1  stat-value">A</div>
                </v-col>

                <!-- K-Index Gauge: Max 9 -->
                <v-col cols="4" class="text-center">
                    <v-progress-circular :model-value="Number(stg.solar.current.geoMagnetic.kIndex / 9) * 100" :max="9"
                        :size="60" :width="8" :color="getKIndexColor(stg.solar.current.geoMagnetic.kIndex)"
                        bg-color="grey-darken-3" rotate="220">
                        <span class="text-h6 font-weight-bold">{{ stg.solar.current.geoMagnetic.kIndex }}</span>
                    </v-progress-circular>
                    <div class="text-subtitle-2 mt-1  stat-value">K</div>
                </v-col>
            </v-row>
        </div>

        <!-- Critical Frequency (foF2) -->
        <v-row no-gutters class="border-t-lg border-white-op py-2 mt-2">
            <!-- foF2 -->
            <v-col cols="4" class="d-flex flex-column align-center border-r ionosphere-value border-white-op">
                <v-icon icon="mdi-wave" v-tooltip:top="'F2 Critical Freq'" color="cyan-lighten-3" size="small"
                    class="mb-1"></v-icon>
                <div class="text-body-2 font-weight-bold  stat-value" style="line-height: 1;">
                    {{ stg.solar.current.ionosphere.fof2 }}
                </div>
                <div class="text-grey-darken-1 mt-1"
                    style="font-size: 0.65rem; text-transform: uppercase; letter-spacing: 0.5px;">
                    foF2
                </div>
            </v-col>

            <!-- MUF -->
            <v-col cols="4" class="d-flex flex-column align-center border-r border-white-op">
                <v-icon icon="mdi-radio-tower" v-tooltip:top="'Max Usable Freq'" color="green-lighten-3" size="small"
                    class="mb-1"></v-icon>
                <div class="text-body-2 font-weight-bold  stat-value" style="line-height: 1;">
                    {{ stg.solar.current.ionosphere.mufd }}
                </div>
                <div class="text-grey-darken-1 mt-1"
                    style="font-size: 0.65rem; text-transform: uppercase; letter-spacing: 0.5px;">
                    MUF
                </div>
            </v-col>

            <!-- hmF2 -->
            <v-col cols="4" class="d-flex flex-column align-center">
                <v-icon icon="mdi-arrow-up-bold-box-outline" v-tooltip:top="'F2 Max Altitude'" color="amber-lighten-3"
                    size="small" class="mb-1"></v-icon>
                <div class="text-body-2 font-weight-bold  stat-value" style="line-height: 1;">
                    {{ stg.solar.current.ionosphere.hmf2 }} {{ stg.units.distance === 'Mi' ? 'mi' : 'km' }}
                </div>
                <div class="text-grey-darken-1 mt-1"
                    style="font-size: 0.65rem; text-transform: uppercase; letter-spacing: 0.5px;">
                    hmF2
                </div>
            </v-col>
        </v-row>


        <div><v-row no-gutters justify="center" class="mt-2 mb-2">
                <v-col v-for="(val, key) in stg.solar.current.scales.current" :key="key" cols="3" class="mx-1">
                    <v-card flat border class="text-center rounded-sm" :color="getScaleColor(val)" theme="light">
                        <!-- The Big Letter -->
                        <div class="text-h4 font-weight-black pt-1" style="line-height: 1;">
                            {{ key.toUpperCase() }}
                        </div>

                        <!-- The Status Text -->
                        <v-sheet class="mt-1 py-0 text-caption font-weight-bold" :color="getScaleColor(val, true)">
                            {{ val > 0 ? val : 'none' }}
                        </v-sheet>
                    </v-card>
                </v-col>
                <span class="text-grey-darken-1 mt-2" style="font-size: 0.70rem;">Latest
                    Observed</span>
            </v-row>

            <v-expansion-panels variant="accordion">
                <v-expansion-panel bg-color="transparent" elevation="0">
                    <v-expansion-panel-title class="text-caption font-weight-bold px-4">
                        Flare/Storm Probabilities
                    </v-expansion-panel-title>

                    <v-expansion-panel-text class="px-4 pb-4">
                        <!-- R1-R2 Probability -->
                        <div class="d-flex align-center mb-2">
                            <span class="text-caption mr-2 prob-label">R1-R2</span>
                            <v-progress-linear :model-value="stg.solar.current.scales.probabilities.rMinor"
                                color="yellow-darken-2" height="8" rounded></v-progress-linear>
                            <span class="text-caption ml-2 prob-percent">{{
                                stg.solar.current.scales.probabilities.rMinor }}%</span>
                        </div>

                        <!-- R3-R5 Probability -->
                        <div class="d-flex align-center mb-2">
                            <span class="text-caption mr-2 prob-label">R3-R5</span>
                            <v-progress-linear :model-value="stg.solar.current.scales.probabilities.rMajor"
                                color="orange-darken-2" height="8" rounded></v-progress-linear>
                            <span class="text-caption ml-2 prob-percent">{{
                                stg.solar.current.scales.probabilities.rMajor }}%</span>
                        </div>

                        <!-- S1+ Probability -->
                        <div class="d-flex align-center mb-1">
                            <span class="text-caption mr-2 prob-label">S1+</span>
                            <v-progress-linear :model-value="stg.solar.current.scales.probabilities.sStorm"
                                color="red-darken-2" height="8" rounded></v-progress-linear>
                            <span class="text-caption ml-2 prob-percent">{{
                                stg.solar.current.scales.probabilities.sStorm }}%</span>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </div>

        <!-- <pre>ionosphere: {{ stg.solar.current.ionosphere }}, solarScales: {{ stg.solar.current.scales }}</pre> -->

    </v-sheet>

</template>


<script>


// import {globalState} from '../../state.js';
import { settings } from './dashboardSettings.js';
export default {
    name: 'LightningCard',
    inheritAttrs: false,

    data() {
        return {
            stg: settings,
            shared: window.G_STATE,
            currentServerIndex: 0,
            connection: null,
            reconnectTimer: null,
            heartbeat: null,
            panel: null,
        };
    },
    beforeUnmount() {
        if (this.solarTimer) {
            clearInterval(this.solarTimer);
            console.log("Solar timer cleared.");
        }
    },
    mounted() {
        // 1. CLEANUP (If you add a timer later)
        if (this.solarTimer) clearInterval(this.solarTimer);

        // 2. LOAD CONFIG
        // Load
        const saved = localStorage.getItem('station_config_v1');
        if (saved && saved !== "undefined") {
            try {
                const config = JSON.parse(saved);
                // Apply your config logic here...
            } catch (e) {
                console.error("Config Sysgen Failure: Malformed JSON in localStorage", e);
                // Optional: clear the bad data so it doesn't crash next time
                // localStorage.removeItem('station_config_v1');
            }
        } else {
            console.log("No saved config found. Loading defaults.");
        }

        // 3. INITIAL FETCH
        this.fetchSolarData();
        this.fetchGeomagneticIndices();
        this.fetchSolarFlux();
        this.fetchIonosphere();
        this.fetchScales();

        // 4. SCHEDULE (Solar data doesn't change fast, maybe every 15-30 mins)
        this.solarTimer = setInterval(() => {
            this.fetchSolarData();
            this.fetchSolarFlux();
            this.fetchGeomagneticIndices();
            this.fetchIonosphere();
            this.fetchScales();
        }, 900000);
    },
    unmounted() { },
    watch: {
        // Watch for unit changes to re-calculate distance
        'stg.units.distance': {
            handler() {
                console.log("Distance unit changed, refreshing Ionosphere...");
                this.fetchIonosphere();
            }
        }
    },
    computed: {},
    methods: {
        async fetchSolarData() {
            const home = this.stg.lightning?.homeLocation || { lat: 34.05, lon: -118.24 };

            // Define your endpoints
            const urls = {
                fof2: `https://prop.kc2g.com/api/point_prediction.json?grid=${home.lat},${home.lon}`,
                flux: "https://services.swpc.noaa.gov/json/f107_cm_flux.json",
                scales: "https://services.swpc.noaa.gov/products/noaa-scales.json",
                indices: "https://services.swpc.noaa.gov/text/daily-geomagnetic-indices.txt"
            };

            try {
                // Since these are independent, you can eventually use Promise.all 
                // to fetch them in parallel for better performance
                console.log("Fetching Solar Data from:", urls.fof2);
                console.log("Fetching Solar Data from:", urls.flux);
                console.log("Fetching Solar Data from:", urls.scales);
                console.log("Fetching Solar Data from:", urls.indices);

                // Your fetch logic goes here...

            } catch (error) {
                console.error("Solar  Error:", error);
            }
        },

        async fetchGeomagneticIndices() {
            const url = "https://services.swpc.noaa.gov/text/daily-geomagnetic-indices.txt";

            try {
                const response = await fetch(url);
                const payload = await response.text(); // Get as text, not JSON

                let aIndex = -1;
                let kIndex = -1;

                const lines = payload.split('\n');
                let i = 0;

                // 1. Find the last non-negative planetary A index (Your original logic)
                for (i = lines.length - 1; i >= 0; i--) {
                    // NOAA indices usually start appearing after the header lines
                    if (lines[i].startsWith(':') || lines[i].startsWith('#') || !lines[i].trim()) continue;

                    aIndex = parseInt(lines[i].substring(59).trim().split(/\s+/)[0]);
                    if (aIndex >= 0) break;
                }

                // 2. Find the last non-negative planetary K index
                if (i >= 0) {
                    let values = lines[i].substring(65).trim().split(/\s+/);
                    for (let j = values.length - 1; j >= 0; j--) {
                        kIndex = parseFloat(values[j]);
                        if (kIndex >= 0) break;
                    }
                }

                // 3. Save to your shared state
                this.stg.solar.current.geoMagnetic.aIndex = aIndex;
                this.stg.solar.current.geoMagnetic.kIndex = kIndex;

                console.log(`Solar: A-Index ${aIndex}, K-Index ${kIndex}`);

            } catch (error) {
                console.error("Geomagnetic fetch failed:", error);
            }
        },

        async fetchSolarFlux() {
            const url = "https://services.swpc.noaa.gov/json/f107_cm_flux.json";

            try {
                const response = await fetch(url);
                const data = await response.json();


                // NOAA returns an array of objects. We want the latest one (index 0).
                if (data && data.length > 0) {
                    const currentFlux = parseFloat(data[0].flux);
                    console.log(`Solar: Flux ${typeof (currentFlux)}`);

                    // Save to state - make sure the variable name matches (currentFlux)
                    this.stg.solar.current.geoMagnetic.flux = currentFlux;
                }



            } catch (error) {
                console.error("SolarFlux fetch failed:", error);
            }
        },
        async fetchIonosphere() {
            const home = this.stg.lightning.homeLocation;

            if (!home || !home.lat || !home.lon) {
                console.warn("Ionosphere fetch skipped: homeLocation undefined.");
                return;
            }

            const url = `/api-kc2g/api/point_prediction.json?grid=${home.lat},${home.lon}`;
            const unit = this.stg.units.distance.toLowerCase() === 'km' ? 1 : 0.621371;
            // console.log(unit);
            try {
                console.log(url);
                const response = await fetch(url);
                const data = await response.json();

                // Destructure the values out of the JSON
                const { fof2, hmf2, mufd, ts } = data;

                // Update state with precision formatting
                const date = new Date(); // The time "Now"
                const formattedTime = date.toLocaleString('en-US', {
                    hour12: true,
                    hour: 'numeric',
                    minute: 'numeric'
                });

                this.stg.solar.current.ionosphere = {
                    fof2: fof2.toFixed(2),
                    hmf2: Math.round(hmf2 * unit),
                    mufd: mufd.toFixed(2),
                    timestamp: formattedTime
                };

                console.log("Ionosphere updated:", this.stg.solar.current.ionosphere);
            } catch (e) {
                console.error("Ionosphere fetch error:", e);
            }
        },

        async fetchScales() {
            const url = "https://services.swpc.noaa.gov/products/noaa-scales.json";
            try {
                const response = await fetch(url);
                const data = await response.json();

                // 1. Get current observed scales from index "0"
                const observed = data["0"];

                // 2. Get probabilities from index "1" (usually the 24h forecast)
                const forecast = data["1"];

                this.stg.solar.current.scales = {
                    current: {
                        r: parseInt(observed.R.Scale) || 0,
                        s: parseInt(observed.S.Scale) || 0,
                        g: parseInt(observed.G.Scale) || 0
                    },
                    probabilities: {
                        rMinor: parseInt(forecast.R.MinorProb) || 0,
                        rMajor: parseInt(forecast.R.MajorProb) || 0,
                        sStorm: parseInt(forecast.S.Prob) || 0
                    }
                };
            } catch (e) {
                console.error("Scales fetch error:", e);
            }
        },
        getSFIColor(sFi) {
            if (sFi <= 70) return '#C81F00';
            if (sFi <= 90) return '#FD9600';
            if (sFi <= 110) return '#FEC801';
            if (sFi <= 150) return '#7fb3cf';
            if (sFi <= 300) return '#92d050';

            return 'red';
        },
        getKIndexColor(k) {
            if (k <= 3) return '#92d050';
            if (k <= 5) return 'yellow';
            if (k <= 7) return 'orange';
            if (k <= 9) return 'red';
            return 'red';
        },
        getAIndexColor(a) {
            if (a <= 10) return '#92d050';
            if (a <= 20) return 'yellow';
            if (a <= 30) return 'orange';
            if (a <= 40) return 'red';
            return 'red';
        },
        getScaleColor(value, isLabel = false) {
            const val = parseInt(value);

            // Default "None" (Green)
            let color = '#92d050';

            if (val >= 4) color = '#ff0000';      // Extreme (Red)
            else if (val >= 3) color = '#ffc000'; // Strong (Orange)
            else if (val >= 1) color = '#ffff00'; // Minor/Moderate (Yellow)

            // Optional: Return a darker/different shade for the bottom label bar
            return color;
        }
    },
};

</script>

<style scoped>
/* Find your card class */
.solarCard {
    background-color: var(--surface-color);
    /* Automatically swaps! */
    color: var(--text-primary);
    border: 1px solid var(--text-secondary);
}

.border-white-op {
    /* This specifically targets the top border created by 'border-t-lg' */
    border-top-color: var(--divider-color) !important;

    /* This makes the line thinner (1px instead of the 'lg' chunky 4px) */
    border-top-width: 1px !important;

    /* Ensures it doesn't try to draw borders on the other 3 sides */
    border-left: none;
    border-right: none;
    border-bottom: none;
}

/* For your v-btn or custom buttons */
.my-button {
    background-color: var(--btn-bg);
    color: var(--text-primary);
}

.stat-value {
    color: var(--value-text);
    font-weight: bold;
}

.label-caption {
    color: var(--text-muted) !important;
    font-size: 0.75rem;
    font-weight: 500;
    /* Makes them slightly bolder for better legibility */
}

/* For specific data text */
.ionosphere-value {
    color: var(--value-text) !important;
    font-weight: bold;
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

/* This targets the 'empty' track of the progress linear */
.v-progress-linear {
    background-color: var(--divider-color) !important;
    overflow: hidden;
}

/* Ensure the probability labels use your muted variable */
.prob-label {
    color: var(--text-muted) !important;
    font-weight: 600;
    width: 65px;
}

/* The percentage numbers can use your primary text color */
.prob-percent {
    color: var(--text-primary) !important;
    width: 35px;
    text-align: right;
}
</style>