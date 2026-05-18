<template>
    <v-card flat class="mx-auto" style="display: block;" bg-color="transparent" variant="flat" height="fit-content">
        <div class="d-flex flex-column ga-2 pb-2">
        </div>
        <v-tabs v-model="settingsView" align-tabs="center">
            <v-tab color="#54b6b2" value="innerTab">
                <v-icon start icon="mdi-cog"></v-icon> General
            </v-tab>
            <v-tab color="orange-darken-2" value="lightning">
                <v-icon start icon="mdi-tune"></v-icon> Lightning
            </v-tab>
        </v-tabs>

        <v-divider></v-divider>

        <v-card-text class="pb-0 d-block">
            <v-window v-model="settingsView" style="width: 300px;" height="auto" continuous>

                <v-window-item value="innerTab" style="overflow-y: auto;">
                    <div class="text-brown-lighten-4 d-flex align-center mt-2">
                        <v-text-field v-model="stg.ui.appName" label="App Name" density="compact" variant="outlined"
                            @keydown.enter.prevent="updateLocation" @change="updateLocation"></v-text-field>
                    </div>

                    <div class="text-subtitle-2 mb-1 text-secondary d-flex align-center">
                        <v-icon color="#d9d2e9" class="mr-2" size="small">mdi-ruler</v-icon>
                        <span>Measurement Units</span>
                    </div>

                    <v-row align="center" no-gutters class="mb-4 px-2">
                        <v-col cols="4">
                            <span class="text-body-2 text-grey-lighten-1">Distance</span>
                        </v-col>
                        <v-col cols="4" class="d-flex justify-end">
                            <v-btn-toggle v-model="stg.units.distance" @update:model-value="changeDistanceUnit"
                                mandatory color="blue-darken-2" density="compact" class="unit-toggle-group">
                                <v-btn value="mi" size="small" class="px-4">Mi</v-btn>
                                <v-btn value="km" size="small" class="px-4">Km</v-btn>
                            </v-btn-toggle>
                        </v-col>
                    </v-row>

                    <v-row align="center" no-gutters class="mb-6 px-2">
                        <v-col cols="4">
                            <span class="text-body-2 text-grey-lighten-1">Pressure</span>
                        </v-col>
                        <v-col cols="4" class="d-flex justify-end">
                            <v-btn-toggle v-model="stg.units.pressure" mandatory color="blue-darken-2" density="compact"
                                @update:model-value="updateLocation" class="unit-toggle-group">
                                <v-btn value="mb" size="small" class="px-4">mb</v-btn>
                                <v-btn value="inch" size="small" class="px-4">in</v-btn>
                            </v-btn-toggle>
                        </v-col>
                    </v-row>

                    <v-row align="center" no-gutters class="mb-6 px-2">
                        <v-col cols="4">
                            <span class="text-body-2 text-grey-lighten-1">Temperature</span>
                        </v-col>
                        <v-col cols="4" class="d-flex justify-end">
                            <v-btn-toggle v-model="stg.units.temperature" mandatory color="blue-darken-2"
                                density="compact" @update:model-value="updateLocation" class="unit-toggle-group">
                                <v-btn value="f" size="small" class="px-4">F</v-btn>
                                <v-btn value="c" size="small" class="px-4">C</v-btn>
                            </v-btn-toggle>
                        </v-col>
                    </v-row>

                    <v-row density="comfortable">
                        <v-col class="text-info" cols="6">
                            <v-text-field v-model.number="stg.lightning.homeLocation.lat" label="Lat" density="compact"
                                variant="outlined" @keydown.enter.prevent="updateLocation"
                                @change="updateLocation"></v-text-field>
                        </v-col>

                        <v-col class="text-info" cols="6">
                            <v-text-field v-model.number="stg.lightning.homeLocation.lon" label="Lon" density="compact"
                                variant="outlined" @keydown.enter.prevent="updateLocation"
                                @change="updateLocation"></v-text-field>
                        </v-col>
                    </v-row>

                    <div class="text-subtitle-2 mb-1 text-secondary">
                        <v-icon size="small" color="#b06e69">mdi-clock-outline</v-icon> Reset Time ({{
                            stg.lightning.resetTime }}m)
                    </div>
                    <v-btn-toggle v-model="stg.lightning.resetTime" density="compact" mandatory color="blue"
                        class="mb-6">
                        <v-btn :value="5" size="small">5m</v-btn>
                        <v-btn :value="10" size="small">10m</v-btn>
                        <v-btn :value="30" size="small">30m</v-btn>
                        <v-btn :value="60" size="small">60m</v-btn>
                    </v-btn-toggle>

                    <v-row density="comfortable">
                        <v-col cols="6">
                            <div class="text-subtitle-2 mb-1 text-secondary">
                                <v-icon color="#4285F4" size="small">mdi-earth</v-icon> Search Radius
                            </div>
                            <v-text-field v-model.number="stg.lightning.searchRadius" density="compact"
                                variant="outlined"></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <div class="text-subtitle-2 mb-1 text-secondary">
                                <v-icon color="orange" size="small">mdi-lightning-bolt</v-icon> Alert Radius
                            </div>
                            <v-text-field v-model.number="stg.lightning.alertThreshold" density="compact"
                                variant="outlined"></v-text-field>
                        </v-col>
                    </v-row>
                </v-window-item>

                <v-window-item class="pb-2 d-block" value="lightning" style="max-height: 60vh; overflow-y: auto;">
                    <div class="text-overline text-orange mb-1">Calculation Method</div>
                    <v-select v-model="stg.lightning.selectedMethod" :items="stg.lightning.calculationMethods"
                        variant="outlined" density="compact"></v-select>

                    <div class="text-overline text-orange mt-2">Sensitivity</div>
                    <v-slider class="mb-6" v-model="stg.lightning.sensitivity" min="0.5" max="10" step="0.5"
                        color="orange" thumb-label="always" show-ticks="always" persistent-hint
                        hint="Higher values reduce 'flip-flopping' of the trend">
                        <template v-slot:append>
                            <v-text-field v-model="stg.lightning.sensitivity" density="compact" style="width: 70px"
                                variant="outlined" hide-details type="number"></v-text-field>
                        </template>
                    </v-slider>

                    <div class="text-overline text-orange mt-2 mb-1">Sample Size</div>
                    <v-text-field v-model.number="stg.lightning.sampleSize" density="compact" variant="outlined"
                        hide-details></v-text-field>

                </v-window-item>

            </v-window>
        </v-card-text>

        <v-card-actions class="pt-4">
            <v-btn variant="outlined" color="blue" size="small" @click="exportToDisk">Backup</v-btn>
            <v-btn variant="outlined" color="green" size="small" @click="$refs.fileInput.click()">Restore</v-btn>
            <input type="file" ref="fileInput" style="display: none" @change="importFromDisk" accept=".json">

        </v-card-actions>
    </v-card>
</template>

<script>
import { settings } from './dashboardSettings.js';
export default {
    props: ['stg'],
    data() {
        return {
            // Keep your WebSockets and Timers here local
            shared: window.G_STATE,
            socket: null,
            timer: null,
            settingsView: 'general'
        };
    },
    methods: {
        changeDistanceUnit(newUnit) {
            if (!newUnit) return;

            // Normalize and assign directly to the global stg object path
            const normalizedUnit = newUnit.toLowerCase();
            console.log("SettingsCard: Toggling unit safely to:", normalizedUnit);

            this.stg.units.distance = normalizedUnit;

            // Save the updated object immediately to disk
            localStorage.setItem('station_config_v1', JSON.stringify(this.stg));
        },

        updateLocation() {
            // 1. Snag values straight from the form template's bound stg properties
            const lat = parseFloat(this.stg.lightning.homeLocation.lat);
            const lon = parseFloat(this.stg.lightning.homeLocation.lon);

            if (isNaN(lat) || isNaN(lon)) {
                console.error("Invalid coordinates. Aborting save.");
                return;
            }

            // 2. Ensure they are locked down as actual formatted numbers back in stg
            this.stg.lightning.homeLocation.lat = lat;
            this.stg.lightning.homeLocation.lon = lon;

            // 3. Commit the entire clean stg configuration to LocalStorage
            localStorage.setItem('station_config_v1', JSON.stringify(this.stg));

            console.log("Station updated successfully:", lat, lon, this.stg?.units?.distance);
        },

        // 1. Safe, live export logic
        exportToDisk() {
            try {
                // 🟢 Grab the LIVE state, not the static file import template
                const cleanData = JSON.parse(JSON.stringify(this.stg));

                // Clean out volatile live tracking arrays so the configuration file stays small
                if (cleanData.weather) {
                    cleanData.weather.current = {};
                    cleanData.weather.forecast = [];
                }
                if (cleanData.lightning) {
                    cleanData.lightning.history = [];
                    // 🟢 Target the corrected structure to prevent recursion crashes
                    delete cleanData.lightning.currentStorm;
                }
                if (cleanData.solar) {
                    cleanData.solar.current = {};
                }

                // Save the cleaned live profile back to local browser storage
                localStorage.setItem('station_config_v1', JSON.stringify(cleanData));

                // Create and trigger the physical file download
                const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(cleanData, null, 2));
                const downloadAnchorNode = document.createElement('a');
                downloadAnchorNode.setAttribute("href", dataStr);
                const safeAppName = this.stg.ui.appName.replace(/[^a-zA-Z0-9-_]/g, '_');
                downloadAnchorNode.setAttribute("download", `{{stg.ui.appName}}_station_settings.json`);
                document.body.appendChild(downloadAnchorNode);
                downloadAnchorNode.click();
                downloadAnchorNode.remove();

                console.log("Live configuration successfully exported to disk.");
            } catch (e) {
                console.error("Export failed:", e);
            }
        },

        // 2. Safe, deep-merge import logic
        importFromDisk(event) {
            const file = event.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = (e) => {
                try {
                    const importedConfig = JSON.parse(e.target.result);

                    // 🟢 Deep recursive merge function to update properties without breaking Vue Proxies
                    const deepMerge = (target, source) => {
                        for (const key in source) {
                            if (source[key] && typeof source[key] === 'object' && !Array.isArray(source[key])) {
                                if (!target[key]) target[key] = {};
                                deepMerge(target[key], source[key]);
                            } else {
                                target[key] = source[key];
                            }
                        }
                    };

                    // Run the deep merge against your live state root
                    deepMerge(this.stg, importedConfig);

                    // Save the newly imported configuration to disk immediately
                    localStorage.setItem('station_config_v1', JSON.stringify(JSON.parse(JSON.stringify(this.stg))));

                    alert("Settings imported successfully! Layout updated.");
                } catch (err) {
                    console.error("Import parsing error:", err);
                    alert("Error parsing the settings file. Ensure it is a valid, uncorrupted JSON profile.");
                }
            };
            reader.readAsText(file);
        },
    },
    computed: {
        displayPressure() {
            const raw = this.weatherData.pressure; // assuming mb from API
            if (this.stg.weather.unit === 'in') {
                return (raw * 0.02953).toFixed(2);
            }
            return raw;
        }
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

/* Gives the toggle group a solid container look */
.unit-toggle-group {
    background-color: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
    overflow: hidden;
}

/* Ensures unselected text is visible but clearly "off" */
.unit-toggle-group .v-btn {
    color: rgba(255, 255, 255, 0.5) !important;
}

/* High contrast for the active selection */
.unit-toggle-group .v-btn--active {
    color: white !important;
}

.unit-toggle-group {
    background-color: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
}
</style>