<template>
    <v-sheet value="solar" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10;">
            <div class="d-flex align-center">
                <v-icon icon="mdi-white-balance-sunny" color="error" size="large" </v-icon>
                    <div class="d-flex flex-column align-start ml-2">
                        <span class="text-subtitle-1 font-weight-bold text-brown-lighten-4"
                            style="line-height: 1.2rem;">Solar</span>
                        <span class="text-grey-darken-1" style="font-size: 0.55rem;">NOAA.org</span>
                    </div>
            </div>
        </div>
    </v-sheet>

</template>


<script>


// import {globalState} from '../../state.js';
import { settings } from './dashboardSettings.js';
export default {
    name: 'LightningCard',
    data() {
        return {
            stg: settings,
            shared: window.G_STATE,
            currentServerIndex: 0,
            connection: null,
            reconnectTimer: null,
            heartbeat: null,
            panel: null
        };
    },
    mounted() {

        // Load
        const saved = localStorage.getItem('station_config_v1');
        if (saved && saved !== "undefined") {
            try {
                const config = JSON.parse(saved);
                console.log(config);
                // Apply your config logic here...
            } catch (e) {
                console.error("Config Sysgen Failure: Malformed JSON in localStorage", e);
                // Optional: clear the bad data so it doesn't crash next time
                // localStorage.removeItem('station_config_v1');
            }
        } else {
            console.log("No saved config found. Loading defaults.");
        }
        const home = this.stg.lightning?.homeLocation || { lat: 34.05, lon: -118.24 };
        const fofTwoUrl = "https://prop.kc2g.com/api/point_prediction.json?grid=" + home.lat + "," + home.lon;
        const noaaSolarFlux = "https://services.swpc.noaa.gov/json/f107_cm_flux.json";
        const noaaJsonScales = "https://services.swpc.noaa.gov/products/noaa-scales.json;";
        const noaaGeoMagnecticIndices = "https://services.swpc.noaa.gov/text/daily-geomagnetic-indices.txt";


        console.log(fofTwoUrl);
    },
    unmounted() { },
    watch: {},
    computed: {},
    methods: {},
};
// fof2 url = "https://prop.kc2g.com/api/point_prediction.json?grid=39.2562,-77.925"

</script>