<template>

    <v-sheet value="solar" transition="fade-transition" flat class="solarCard mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10;">
            <div class="d-flex align-center">
                <v-icon icon="mdi-sun-wireless" color="error" size="large"> </v-icon>
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
                    <div class="text-subtitle-2 mt-1 stat-value" v-tooltip:bottom="'Planetary Ap'">A</div>
                </v-col>

                <!-- K-Index Gauge: Max 9 -->
                <v-col cols="4" class="text-center">
                    <v-progress-circular :model-value="Number(stg.solar.current.geoMagnetic.kIndex / 9) * 100" :max="9"
                        :size="60" :width="8" :color="getKIndexColor(stg.solar.current.geoMagnetic.kIndex)"
                        bg-color="grey-darken-3" rotate="220">
                        <span class="text-h6 font-weight-bold">{{ stg.solar.current.geoMagnetic.kIndex }}</span>
                    </v-progress-circular>
                    <div class="text-subtitle-2 mt-1 stat-value" v-tooltip:bottom="'Planetary Kp'">K</div>
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
                    {{ convertedHmf2 }} {{ stg.units.distance.toLowerCase() === 'mi' ? 'mi' : 'km'
                    }}
                </div>
                <div class="text-grey-darken-1 mt-1"
                    style="font-size: 0.65rem; text-transform: uppercase; letter-spacing: 0.5px;">
                    hmF2
                </div>
            </v-col>
        </v-row>


        <div><v-row no-gutters justify="center" class="mt-2 mb-2">
                <v-col v-for="(val, key) in stg.solar.current.scales.current" :key="key" cols="3" class="mx-1">
                    <v-card flat border class="text-center rounded-sm" :color="getScaleColor(val, true)" theme="light">
                        <!-- The Big Letter -->
                        <div class="text-h4 font-weight-black pt-1" style="line-height: 1;">
                            {{ key.toUpperCase() }} {{ val > 0 ? val : '' }}
                        </div>

                        <!-- The Status Text -->
                        <v-sheet class="mt-1 py-0  font-weight-bold" :color="getScaleColor(val, true)">
                            {{ getScaleCondition(val) }}
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
                            <span class="mr-2 prob-label">R1-R2</span>
                            <v-progress-linear :model-value="stg.solar.current.scales.probabilities.rMinor"
                                color="yellow-darken-2" height="8" rounded></v-progress-linear>
                            <span class="text-caption ml-2 prob-percent">{{
                                stg.solar.current.scales.probabilities.rMinor }}%</span>
                        </div>

                        <!-- R3-R5 Probability -->
                        <div class="d-flex align-center mb-2">
                            <span class=" mr-2 prob-label">R3-R5</span>
                            <v-progress-linear :model-value="stg.solar.current.scales.probabilities.rMajor"
                                color="orange-darken-2" height="8" rounded></v-progress-linear>
                            <span class="text-caption ml-2 prob-percent">{{
                                stg.solar.current.scales.probabilities.rMajor }}%</span>
                        </div>

                        <!-- S1+ Probability -->
                        <div class="d-flex align-center mb-1">
                            <span class="mr-2 prob-label">S1+</span>
                            <v-progress-linear :model-value="stg.solar.current.scales.probabilities.sStorm"
                                color="red-darken-2" height="8" rounded></v-progress-linear>
                            <span class="text-caption ml-2 prob-percent">{{
                                stg.solar.current.scales.probabilities.sStorm }}%</span>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </div>
    </v-sheet>
</template>

<script>


// import {globalState} from '../../state.js';
import { settings } from './dashboardSettings.js';
import { reactive } from 'vue';
export default {
    name: 'LightningCard',
    inheritAttrs: false,
    props: {
        stg: {
            type: Object,
            required: true
        }
    },

    data() {
        return {
            // stg: reactive(settings),
            shared: window.G_STATE,
            currentServerIndex: 0,
            connection: null,
            reconnectTimer: null,
            heartbeat: null,
            panel: null
        };
    },
    beforeUnmount() {
        if (this.solarTimer) {
            clearInterval(this.solarTimer);
        }
    },
    mounted() {

        // window.dashboard = this.stg;

        if (this.solarTimer) clearInterval(this.solarTimer);

        const saved = localStorage.getItem('station_config_v1');
        if (saved && saved !== "undefined") {
            try {
                const config = JSON.parse(saved);
                // Apply your config logic here...
            } catch (e) {
            }
        } else {
        }


        this.fetchSolarData();
        this.fetchGeomagneticIndices();
        this.fetchSolarFlux();
        this.fetchIonosphere();
        this.fetchScales();

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
        'stg.units.distance': {
            handler() {
                this.fetchIonosphere();
            },
            deep: true,
            immediate: true
        }
    },

    computed: {
        convertedHmf2() {
            // Safe navigation: ensure every level exists before checking hmf2
            const solar = this.stg?.solar;
            const iono = solar?.current?.ionosphere;
            const raw = iono?.hmf2;

            if (raw === undefined || raw === null) return '--';

            const unit = String(this.stg.units.distance || 'Mi').trim().toLowerCase();
            const isMi = unit === 'mi';

            return isMi
                ? Math.round(raw * 0.621371)
                : Math.round(raw);
        }
    },

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

            } catch (error) {
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

                this.stg.solar.current.geoMagnetic.aIndex = aIndex;
                this.stg.solar.current.geoMagnetic.kIndex = kIndex;

            } catch (error) {
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

                    // Save to state - make sure the variable name matches (currentFlux)
                    this.stg.solar.current.geoMagnetic.flux = currentFlux;
                }



            } catch (error) {

            }
        },
        async fetchIonosphere() {
            const home = this.stg.lightning.homeLocation;

            if (!home || !home.lat || !home.lon) {

                return;
            }

            const url = `/api-kc2g/api/point_prediction.json?grid=${home.lat},${home.lon}`;
            const unit = this.stg.units.distance.toLowerCase() === 'km' ? 1 : 0.621371;

            try {

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
                    hmf2: hmf2.toFixed(1),
                    mufd: mufd.toFixed(2),
                    timestamp: formattedTime
                };
            } catch (e) {
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

            if (val === 5) color = '#C80000';
            else if (val === 4) color = '#FF0000';
            else if (val === 3) color = '#FF9600';
            else if (val === 2) color = '#FFC800';
            else if (val === 1) color = '#F6EB14';

            // Optional: Return a darker/different shade for the bottom label bar
            return color;
        },
        getScaleCondition(value, isLabel = false) {
            const val = parseInt(value) || 0;

            let condition = 'None';

            if (val === 5) condition = 'Extreme';
            else if (val === 4) condition = 'Severe';
            else if (val === 3) condition = 'Strong';
            else if (val === 2) condition = 'Moderate';
            else if (val === 1) condition = 'Minor';
            else if (val === 0) condition = 'Quiet';

            return condition;
        }
    },
};

</script>

<style scoped>
.solarCard {
    background-color: var(--surface-color);

    color: var(--text-primary);
    border: 1px solid var(--text-secondary);
}

.border-white-op {
    border-top-color: var(--divider-color) !important;
    border-top-width: 1px !important;
    border-left: none;
    border-right: none;
    border-bottom: none;
}

.my-button {
    background-color: var(--btn-bg);
    color: var(--text-primary);
}

.stat-value {
    color: #D7CCC8;
    font-weight: bold;
}

.label-caption {
    color: #D7CCC8 !important;
    font-size: 0.75rem;
    font-weight: 500;
}

.ionosphere-value {
    color: #D7CCC8 !important;
    font-weight: bold;
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

.text-caption {
    color: #D7CCC8
}

.val {
    font-size: 0.80rem;
    color: #D7CCC8;
    font-weight: 600;
    font-family: 'Roboto Mono', monospace;
}

.v-progress-linear {
    background-color: #D7CCC8 !important;
    overflow: hidden;
}

.prob-label {
    color: #D7CCC8 !important;
    font-weight: 600;
    width: 65px;
}

.prob-percent {
    color: #D7CCC8 !important;
    width: 35px;
    text-align: right;
}
</style>