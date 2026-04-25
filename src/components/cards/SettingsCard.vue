<template>
    <!-- <pre>` stg.lighting.homelocation:  {{ stg.lightning.homeLocation }}`</pre> -->

    <v-card flat class="mx-auto" bg-color="transparent">

        <v-tabs v-model="stg.ui.activeTab" align-tabs="center">
            <v-tab color="#54b6b2" value="general">
                <v-icon start icon="mdi-cog"></v-icon> General
            </v-tab>
            <v-tab color="orange-darken-2" value="tuning">
                <v-icon start icon="mdi-tune"></v-icon> Tuning
            </v-tab>
            <v-tab color="info" value="features">
                <v-icon start icon="mdi-feature-search"></v-icon> Features
            </v-tab>
        </v-tabs>

        <v-divider></v-divider>

        <v-card-text>
            <v-window v-model="stg.ui.activeTab" style="width: 300px" ;>

                <v-window-item value="general" style="height: 65vh; overflow-y: auto;">

                    <div class="text-brown-lighten-4 d-flex align-center mt-2">
                        <v-text-field label="Dashboard Name" density="compact" variant="outlined"
                            v-model="stg.ui.appName"></v-text-field>
                    </div>

                    <div class="text-subtitle-2 mb-4 text-secondary d-flex align-center">
                        <v-icon color="#d9d2e9" class="mr-2">mdi-ruler</v-icon>
                        <span>Measurement Units</span>
                    </div>

                    <v-row align="center" no-gutters class="mb-4 px-2">
                        <v-col cols="4">
                            <span class="text-body-2 text-grey-lighten-1">Distance</span>
                        </v-col>
                        <v-col cols="4" class="d-flex justify-end">
                            <v-btn-toggle v-model="stg.weather.distanceUnit" mandatory color="blue-darken-2"
                                density="compact" class="unit-toggle-group">
                                <v-btn value="Mi" size="small" class="px-4">Mi</v-btn>
                                <v-btn value="Km" size="small" class="px-4">Km</v-btn>
                            </v-btn-toggle>
                        </v-col>
                    </v-row>

                    <v-row align="center" no-gutters class="mb-6 px-2">
                        <v-col cols="4">
                            <span class="text-body-2 text-grey-lighten-1">Pressure</span>
                        </v-col>
                        <v-col cols="4" class="d-flex justify-end">
                            <v-btn-toggle v-model="stg.weather.pressureUnit" mandatory color="blue-darken-2"
                                density="compact" @update:model-value="updateLocation" class="unit-toggle-group">
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
                            <v-btn-toggle v-model="stg.weather.tempUnit" mandatory color="blue-darken-2"
                                density="compact" @update:model-value="updateLocation" class="unit-toggle-group">
                                <v-btn value="fahrenheit" size="small" class="px-4">F</v-btn>
                                <v-btn value="celsius" size="small" class="px-4">C</v-btn>
                            </v-btn-toggle>
                        </v-col>
                    </v-row>

                    <v-row density="comfortable" class="mb-2">
                        <v-col class="text-info" cols="6">
                            <v-text-field v-model.number="localLat" label="Lat" density="compact" variant="outlined"
                                @keydown.enter.prevent="updateLocation"></v-text-field>
                        </v-col>

                        <v-col class="text-info" cols="6">
                            <v-text-field v-model.number="localLon" label="Lon" density="compact" variant="outlined"
                                @keydown.enter.prevent="updateLocation"></v-text-field>
                        </v-col>
                    </v-row>

                    <div class="text-subtitle-2 mb-2 text-secondary">
                        <v-icon size="large" color="#b06e69">mdi-clock-outline</v-icon> Reset Time ({{
                            stg.lightning.resetTime }}m)
                    </div>
                    <v-btn-toggle v-model="stg.lightning.resetTime" mandatory color="blue" class="mb-6">
                        <v-btn :value="5">5</v-btn>
                        <v-btn :value="10">10</v-btn>
                        <v-btn :value="30">30</v-btn>
                        <v-btn :value="60">60</v-btn>
                    </v-btn-toggle>

                    <v-row density="comfortable">
                        <v-col cols="6">
                            <div class="text-subtitle-2 mb-1 text-secondary">
                                <v-icon color="#4285F4" size="large">mdi-earth</v-icon> Search Radius
                            </div>
                            <v-text-field v-model.number="stg.lightning.searchRadius" density="compact"
                                variant="outlined"></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <div class="text-subtitle-2 mb-1 text-secondary">
                                <v-icon color="orange" size="large">mdi-lightning-bolt</v-icon> Alert Radius
                            </div>
                            <v-text-field v-model.number="stg.lightning.alertThreshold" density="compact"
                                variant="outlined"></v-text-field>
                        </v-col>
                    </v-row>
                </v-window-item>

                <v-window-item value="tuning" style="height: 50vh; overflow-y: auto;">
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

                    <div class="text-overline text-orange mt-2">Sample Size</div>
                    <v-text-field v-model.number="stg.lightning.sampleSize" density="compact" variant="outlined"
                        hide-details></v-text-field>

                    <div class="text-overline text-orange mt-6">Chase Mode</div>
                    <v-btn icon="mdi-radar" variant="text" size="x-large" density="compact"
                        :color="stg.lightning.chaseMode ? 'cyan-accent-2' : 'grey-darken-1'"
                        :class="['ml-2', { 'pulse-animation': stg.lightning.chaseMode }]"
                        @click="stg.lightning.chaseMode = !stg.lightning.chaseMode">
                    </v-btn>
                </v-window-item>

                <v-window-item value="features" class="text-caption text-grey mt-1"
                    style="height: 50vh; overflow-y: auto;">
                    <h2> Lightning Monitor Features</h2>
                    <h3>📡 Data &amp; Connection</h3>
                    <ul>
                        <li><strong>Source:</strong> Real-time stream from <code>blitzortung.org</code>.
                        </li>
                        <li><strong>Dynamic WSS:</strong> Automatic server rotation and key extraction</li>
                        <li><strong>Lempel–Ziv–Welch (LZW):</strong> Custom decompression algorithm to
                            decode raw binary strike data.
                        </li>
                        <li><strong>State Management:</strong> Uses Browser Context to maintain persistent
                            dashboard data across refreshes.</li>
                    </ul>
                    <h3>🧠 Logic Engine</h3>
                    <ul>
                        <li><strong>Haversine Formula:</strong> Precise distance calculation from your
                            configured <code>homeLocation</code>.</li>
                        <li><strong>Refined Trend Tracking:</strong> Compares the &quot;Near Distance&quot;
                            (closest strike) of the first half of the buffer vs. the second half to
                            determine movement.</li>
                        <li><strong>Tunable Sensitivity:</strong> Uses a configurable &quot;Dead Zone&quot;
                            (e.g., 2.0 units) to prevent the trend arrow from flickering during stationary
                            storms.</li>
                        <li><strong>Strikes/minute:</strong> Calculates a rolling strike frequency and
                            tracks the <strong>Peak Frequency</strong> of the current event.</li>
                        <li><strong>Auto Tune</strong> When selected applies the strike frequency to the
                            sample size
                            used in Trend tracking. This applies the trending to bursty strike data.</li>

                        <li><strong>Auto-Reset:</strong> Sweeps strikes older than <code>resetTime</code>
                            (Default: 30m) to ensure the UI returns to &quot;Clear&quot; once a storm
                            passes.</li>
                    </ul>
                    <h3>🎨 Dashboard UI</h3>
                    <ul>
                        <li><strong>Strike Frequency</strong> Strikes per minute</li>
                        <li><strong>Action Buttons</strong>
                            <ul>
                                <li><v-icon>mdi-radar</v-icon> Strikes per minute / Chase Mode. Chip
                                    colors track strikes per minute (less than 10: Blue, up to 20 Orange,
                                    Over 20
                                    Red)
                                </li>
                                <li>🔇Mute Strike Alert Audio</li>
                                <li><v-icon>mdi-trash-can</v-icon> Clearable Strike Buffer </li>
                                <li>⚙️ Settings/Tuning Modals</li>
                            </ul>
                        </li>
                        <li><strong>Status Banners:</strong>
                            <ul>
                                <li>🔴 <strong>DANGER:</strong> Strike detected within
                                    <code>Alert Threshold</code>.
                                </li>
                                <li>🟠 <strong>ACTIVE:</strong> Strike detected within
                                    <code>Search Radius</code>.
                                </li>
                                <li>🛡️ <strong>CLEAR:</strong> No active strikes in the buffer.</li>
                            </ul>
                        </li>
                        <li><strong>Directional Compass:</strong> Rotates an <code>mdi-navigation</code>
                            icon based on the calculated bearing (0° to 359°) of the most recent strike.
                        </li>
                        <li><strong>Trend Indicators:</strong> Textual Updates (Approaching, Receding,
                            Stationary) based on processed history.</li>
                        <li><strong>Tabular Settings:</strong> Organized modal interface separating
                            <strong>General</strong> setup from <strong>Tuning</strong> parameters.
                        </li>
                    </ul>
                    <h3>⚙️ Settings (General)</h3>
                    <ul>
                        <li><strong>Unit Toggle:</strong> Seamlessly switch between <strong>Miles
                                (Mi)</strong> and <strong>Kilometers (Km)</strong>. All existing history and
                            thresholds are mathematically converted on-the-fly.</li>
                        <li><strong>Home Location:</strong> User-definable Latitude and Longitude for the
                            monitoring center. </li>
                        <li><strong>Reset Time:</strong> Selectable window [5, 10, 30, 60 mins] to determine
                            how long a strike remains &quot;active&quot; in the system.</li>
                        <li><strong>Search &amp; Alert Radii:</strong> Custom distance triggers for UI state
                            changes and audible alerts.</li>
                    </ul>
                    <h3>🛠️ Tuning (Advanced)</h3>
                    <ul>
                        <li><strong>Calculation Mode:</strong> Choose the mathematical approach for trend
                            analysis (<code>Closest</code>, <code>Average</code>, or
                            <code>Percentile(20)</code>).
                        </li>
                        <li><strong>Trend Sensitivity:</strong> Adjust the movement threshold (e.g., 0.5 to
                            5.0 units) required to trigger an &quot;Approaching&quot; or
                            &quot;Receding&quot; status.</li>
                        <li><strong>Sample Size:</strong> Set the minimum number of strikes required in the
                            buffer before the system attempts to calculate a trend.</li>
                        <li><strong>Chase Mode</strong> Sync the Sample Size value to strikes per minute
                            value.</li>
                    </ul>
                    <h3>💾 Persistence</h3>
                    <ul>
                        <li><strong>File Storage:</strong> Backup <code>lightning_settings.json</code> to
                            the
                            local download directory. Restore <code>lightning_settings.json</code> from the
                            local
                            download directory</li>
                        <li><strong>JSON Schema:</strong> Config and Strike Data Arrays</li>
                    </ul>
                </v-window-item>
            </v-window>
        </v-card-text>


        <v-card-actions>
            <v-btn variant="outlined" color="blue" size="small" @click="exportToDisk">Backup</v-btn>
            <v-btn variant="outlined" color="green" size="small" @click="$refs.fileInput.click()">Restore</v-btn>
            <input type="file" ref="fileInput" style="display: none" @change="importFromDisk" accept=".json">
            <v-spacer></v-spacer>
            <v-btn color="primary" variant="elevated" @click="updateLocation">
                Update
            </v-btn>
        </v-card-actions>
    </v-card>


</template>

<script>
import { settings } from './dashboardSettings.js';
export default {
    props: {
        modelValue: Boolean, // This maps to v-model
        stg: Object,         // Your settings object
    },
    data() {
        return {
            stg: settings,
            // Keep your WebSockets and Timers here local
            socket: null,
            timer: null,
            localLat: settings.lightning.homeLocation.lat,
            localLon: settings.lightning.homeLocation.lon,
        };
    },
    methods: {
        updateLocation() {
            // 1. Validate the inputs before converting
            const newLat = parseFloat(this.localLat);
            const newLon = parseFloat(this.localLon);
            const newAppName = this.appName;

            // 2. Safety Check: If either is Not a Number, stop the bus!
            if (isNaN(newLat) || isNaN(newLon)) {
                console.error("Invalid coordinates entered. Aborting save.");
                alert("Please enter valid numeric coordinates.");
                return;
            }

            // 3. Write to the shared reactive object
            settings.lightning.homeLocation.lat = newLat;
            settings.lightning.homeLocation.lon = newLon;

            // 4. Update the Weather settings too
            settings.weather.current.lat = newLat;
            settings.weather.current.lon = newLon;

            // update UI settings
            //  settings.ui.appName = newAppName;

            // 5. Commit to LocalStorage
            localStorage.setItem('station_config_v1', JSON.stringify(settings));

            // 6. Final confirmation
            console.log("Station updated successfully:", newLat, newLon, newAppName);
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