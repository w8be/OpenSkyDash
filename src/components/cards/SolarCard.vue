<template>
    <v-sheet value="solar" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10;">
            <div class="d-flex align-center">
                <v-icon icon="mdi-white-balance-sunny" color="error" size="large" </v-icon>
                    <div class="d-flex flex-column align-start ml-2">
                        <span class="text-subtitle-1 font-weight-bold text-brown-lighten-4"
                            style="line-height: 1.0rem; font-size: 1.2rem;">Solar</span>
                        <span class="text-grey-darken-1" style="font-size: 0.55rem;">NOAA.org / KC2G.com</span>
                        <!-- <span class="text-grey-darken-1" style="font-size: 0.50rem;">kc2g.com</span> -->
                    </div>
            </div>
        </div>
        <pre>a: {{ stg.solar.current.geoMagnetic.aIndex }},  k: {{ stg.solar.current.geoMagnetic.kIndex }}, sFi: {{ stg.solar.current.geoMagnetic.flux }}, 
ionosphere: {{ stg.solar.current.ionosphere }}, 
solarScales: {{ stg.solar.current.scales }}</pre>
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
    mounted() {
        // 1. CLEANUP (If you add a timer later)
        if (this.solarTimer) clearInterval(this.solarTimer);

        // 2. LOAD CONFIG
        const saved = localStorage.getItem('station_config_v1');
        // ... your existing JSON.parse logic ...

        // 3. INITIAL FETCH
        this.fetchSolarData();
        this.fetchGeomagneticIndices();
        this.fetchSolarFlux();

        // 4. SCHEDULE (Solar data doesn't change fast, maybe every 15-30 mins)
        this.solarTimer = setInterval(() => {
            this.fetchSolarData();
            this.fetchSolarFlux();
        }, 900000);
    },
    unmounted() { },
    watch: {},
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
                console.error("Solar Sysgen Error:", error);
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
                    const currentFlux = data[0].flux;
                    console.log(`Solar: Flux ${currentFlux}`);

                    // Save to state - make sure the variable name matches (currentFlux)
                    this.stg.solar.current.geoMagnetic.flux = currentFlux;
                }



            } catch (error) {
                console.error("SolarFlux fetch failed:", error);
            }
        },
        async fetchIonosphere() {
            const url = "YOUR_IONOSPHERE_ENDPOINT"; // e.g., KC2G or similar API
            try {
                const response = await fetch(url);
                const data = await response.json();

                // Destructure the values out of the JSON
                const { fof2, hmf2, mufd, ts } = data;

                // Update state with precision formatting
                this.stg.solar.current.ionosphere = {
                    fof2: fof2.toFixed(2),
                    hmf2: Math.round(hmf2),
                    mufd: mufd.toFixed(2),
                    timestamp: ts
                };

                console.log("Ionosphere updated:", this.stg.solar.current.ionosphere);
            } catch (e) {
                console.error("Ionosphere fetch error:", e);
            }
        },

        async fetchScales() {
            const url = "https://services.swpc.noaa.gov/json/noaa-scales.json";
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
        }
    },
};

</script>