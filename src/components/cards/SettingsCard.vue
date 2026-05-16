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
            <v-window v-model="settingsView" style="width: 300px" height="auto" continuous;>

                <v-window-item value="innerTab" style="overflow-y: auto;">
                    <div class="text-brown-lighten-4 d-flex align-center mt-2">
                        <v-text-field label="Dashboard Name" density="compact" variant="outlined"
                            prepend-inner-icon="mdi-rename-box" v-model="stg.ui.appName"></v-text-field>
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
                            <v-text-field v-model.number="localLat" label="Lat" density="compact" variant="outlined"
                                @keydown.enter.prevent="updateLocation"></v-text-field>
                        </v-col>

                        <v-col class="text-info" cols="6">
                            <v-text-field v-model.number="localLon" label="Lon" density="compact" variant="outlined"
                                @keydown.enter.prevent="updateLocation"></v-text-field>
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
            isDark: localStorage.getItem('theme') === 'dark',
            socket: null,
            timer: null,
            localLat: this.stg?.lightning?.homeLocation?.lat,
            localLon: this.stg?.lightning?.homeLocation?.lon,
            localDistanceUnit: this.stg?.units?.distance,
            localTempUnit: this.stg?.units?.temperature,
            localPressureUnit: this.stg?.units?.pressure,
            appName: this.stg?.ui.appName,
            settingsView: 'general'
        };
    },
    methods: {
        changeDistanceUnit(newUnit) {
            if (!newUnit) return;

            // Force it to lowercase ('mi' or 'km') so the state engine recognizes it
            const normalizedUnit = newUnit.toLowerCase();
            console.log("SettingsCard: Toggling unit safely to:", normalizedUnit);

            this.$emit('update-distance', normalizedUnit);
        },
        updateLocation() {
            const newLat = parseFloat(this.localLat);
            const newLon = parseFloat(this.localLon);

            if (isNaN(newLat) || isNaN(newLon)) {
                console.error("Invalid coordinates. Aborting save.");
                return;
            }

            // 1. Update Home Location (The source of truth for all cards)
            this.settings.lightning.homeLocation.lat = newLat;
            this.settings.lightning.homeLocation.lon = newLon;

            // 3. Update UI settings
            this.settings.ui.appName = this.appName;

            // 4. Commit the entire reactive object to LocalStorage
            localStorage.setItem('station_config_v1', JSON.stringify(this.stg));

            console.log("Station updated successfully:",
                newLat, newLon, this.stg?.units?.distance, this.stg?.units?.temperature);
        },

        saveSettings() {
            // Just write the current state of the settings object to LocalStorage
            localStorage.setItem('station_config_v1', JSON.stringify(settings));
            console.log("Units/Settings updated in LocalStorage");
        },
        // 1. Logic to take your 'stg' object and save it as a JSON file
        exportToDisk() {
            try {
                // 1. Create a DEEP CLONE (A completely separate copy in memory)
                const cleanData = JSON.parse(JSON.stringify(settings));

                // 2. Scrub the Activity Data from the clone
                cleanData.weather.current = {};
                cleanData.weather.forecast = [];
                cleanData.lightning.history = [];

                // 3. Scrub the recursion (The Nesting Doll Fix)
                delete cleanData.lightning.lightning;

                // 4. PERSISTENCE: Save the clean version to browser memory
                localStorage.setItem('station_config_v1', JSON.stringify(cleanData));

                // Create the physical file download
                const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(cleanData, null, 2));
                const downloadAnchorNode = document.createElement('a');
                downloadAnchorNode.setAttribute("href", dataStr);
                downloadAnchorNode.setAttribute("download", "station_settings.json");
                document.body.appendChild(downloadAnchorNode);
                downloadAnchorNode.click();
                downloadAnchorNode.remove();

                console.log("Export successful. LocalStorage updated with WV coordinates.");
            } catch (e) {
                console.error("Export failed:", e);
            }
        },

        // 2. Logic to take a JSON file and overwrite your 'stg' object
        importFromDisk(event) {
            const file = event.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = (e) => {
                try {
                    const json = JSON.parse(e.target.result);
                    // Object.assign keeps the reactivity alive while updating values
                    Object.assign(this.stg, json);
                } catch (err) {
                    alert("Error parsing the settings file. Ensure it is a valid JSON.");
                }
            };
            reader.readAsText(file);
        },
        toggleTheme() {
            this.isDark = !this.isDark;
            // Directly update your global settings object
            this.stg.ui.theme = this.isDark ? 'dark' : 'light';
            localStorage.setItem('theme', this.stg.ui.theme);
        }
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