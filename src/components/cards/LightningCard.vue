<template>

    <v-sheet value="lightning" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">
        <!-- <pre>{{ stg.lightning.resetTime }}</pre> -->

        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10; ">
            <div class="d-flex align-center">
                <v-icon icon="mdi-flash" color="amber" size="large"
                    :class="{ 'pulsing-icon': (stg.lightning.currentStorm.frequency > 0) }">
                </v-icon>
                <div class="d-flex flex-column align-start">
                    <span class="text-subtitle-1 font-weight-bold text-brown-lighten-4"
                        style="line-height: 1.2rem;">Lightning</span>
                    <span class="text-grey-darken-1" style="font-size: 0.55rem;">Blitzortung.org</span>
                </div>
            </div>

            <div class="d-flex justify-space-between align-center">
                <v-chip size="x-small" :color="freqColor" variant="flat"
                    class="font-weight-bold d-flex justify-center mr-2"
                    style="font-size: 0.90rem; font-weight: bold; min-width: 70px;">
                    {{ stg.lightning.currentStorm.frequency || 0 }}/min

                    <!-- <template v-slot:append>
                        <v-btn v-tooltip:top="'Chase Mode'" icon="mdi-radar" variant="text" size="x-small"
                            class="ml-2 ma-0" density="compact"
                            :color="stg?.lightning.isSnapped ? 'cyan-accent-2' : 'grey-lighten-1'"
                            :class="{ 'ml-2 ma-0, pulse-animation': stg?.lightning.isSnapped }"
                            @click="setThresholdFromCurrent"></v-btn>
                    </template> -->
                </v-chip>

                <div class="d-flex align-center">
                    <v-btn v-tooltip:top="'Mute'" icon variant="plain" size="small" @click="toggleMute" class="ma-0"
                        width="28">
                        <v-icon :icon="stg?.lightning.isMuted ? 'mdi-volume-off' : 'mdi-volume-high'"
                            :color="stg?.lightning.isMuted ? 'red' : 'green'" size="small">
                        </v-icon>
                    </v-btn>
                    <v-btn v-tooltip:top="'Clear Buffer'" icon variant="plain" size="small" @click="resetBuffer"
                        class="ma-0" width="28">
                        <v-icon icon="mdi-trash-can-outline"
                            :color="(stg?.lightning.history?.length > 0) ? 'blue' : 'grey-darken-1'" size="small">
                        </v-icon>
                    </v-btn>
                </div>

            </div>
        </div>

        <template v-if="stg?.lightning">
            <div v-if="stg.lightning.currentStorm.distance > 0 && stg.lightning.currentStorm.distance <= stg.lightning.alertThreshold"
                class="danger-banner text-center py-1 font-weight-bold text-white bg-red-darken-4">
                <v-icon icon="mdi-alert-octagon" size="x-small" class="mr-1"></v-icon>
                TAKE ACTION: Immediate Danger
            </div>

            <div v-else-if="stg.lightning.currentStorm.distance > 0 && stg.lightning.currentStorm.distance <= stg.lightning.searchRadius"
                class="text-center py-1 font-weight-bold text-white bg-orange-darken-3">
                <v-icon icon="mdi-eye-check" size="x-small" class="mr-1"></v-icon>
                CAUTION: Strikes In Area
            </div>

            <div v-else class="text-center font-weight-bold text-white bg-green-darken-3">
                <v-icon icon="mdi-shield-check" size="x-small" class="mr-1"></v-icon>
                STATUS: Clear / Monitoring
            </div>
        </template>

        <v-card-text class="pa-4">
            <div
                v-if="stg.lightning.currentStorm.distance > 0 && stg.lightning.currentStorm.distance <= stg.lightning.searchRadius">
                <div class="d-flex justify-space-between align-end mb-4">
                    <div class="d-flex align-baseline">
                        <div class="display-value text-brown-lighten-4">{{ convertedDistance }}</div>
                        <div class="unit-text ml-1">{{ stg.lightning?.unit }}</div>
                    </div>
                    <div class="text-right d-flex flex-column align-center" style="min-width: 100px;">
                        <v-icon icon="mdi-navigation"
                            :style="{ transform: `rotate(${stg.lightning.currentStorm?.bearing || 0}deg)`, transition: 'transform 0.5s' }"
                            size="28" color="brown-lighten-4"></v-icon>
                        <div :class="['trend-text font-weight-black mt-1 text-capitalize', trendColor]">
                            {{ stg.lightning.currentStorm?.trend }}
                        </div>
                        <div class="unit-text ml-1" style="font-size: 1.0rem;">
                            {{ getDir(stg.lightning.currentStorm?.bearing) }}
                        </div>
                    </div>
                </div>
            </div>

            <div v-else-if="stg.lightning.history.length === 0" class="text-center text-grey-darken-1 py-6">
                <v-icon icon="mdi-shield-check-outline" size="48"></v-icon>
                <div class="text-caption font-weight-bold text-uppercase">Quiet</div>
            </div>

            <!-- <div v-if="hasActiveAlert"> -->
            <div v-if="stg.lightning.history.length && stg.lightning.history.length > 0">
                <!-- <pre>{{ stg.lightning.history.length }}</pre> -->
                <div class="sparkline-container mt-2" style="position: relative;">

                    <template v-if="stg.lightning.history.length > 0">
                        <!-- <pre>{{ stg.lightning.currentStorm.distance }}  {{ stg.lightning.searchRadius }}</pre> -->
                        <v-sparkline :model-value="sparklineValues" :gradient="['#4caf50', '#ffeb3b', '#f44336']"
                            smooth="100" line-width="2" height="75" fill padding="3"></v-sparkline>
                        <div style="
                    position: absolute; 
                    bottom: 5px; 
                    left: 10px; 
                    right: 10px; 
                    display: flex; 
                    justify-content: space-between; 
                    pointer-events: none;
                    z-index: 2;
                    text-shadow: 1px 1px 2px rgba(0,0,0,0.9);
                    transition: all 0.3s ease;
                " :style="{
                    color: sparklineValues.some(v => v > 0) ? '#FFFFFF' : '#757575',
                    opacity: sparklineValues.some(v => v > 0) ? '1.0' : '0.5'
                }" class="text-caption font-weight-bold">
                            <span>-{{ stg.lightning.resetTime }}m</span>
                            <span class="text-grey-darken-1 ml-2 mt-1" style="font-size: 0.65rem;">Closer strikes peak
                                higher
                            </span>
                            <span>NOW</span>
                        </div>

                    </template>
                </div>

                <v-expansion-panels v-model="stg.lightning.ui.panel" flat class="mt-2">
                    <v-expansion-panel value="strikes" bg-color="transparent">
                        <v-expansion-panel-title :ripple="false"
                            class="text-capitalize text-caption font-weight-bold text-brown-lighten-4"
                            :class="[(stg?.lightning.history.length > 0) ? 'text-green-accent-2' : 'text-grey-darken-1']">
                            Recent Strikes
                        </v-expansion-panel-title>
                        <v-expansion-panel-text>
                            <div v-for="(strike, index) in recentStrikes" :key="index">
                                <v-row no-gutters align="center" class="text-caption">
                                    <v-col cols="4" class="text-left text-grey-lighten-1 time-col"
                                        style="white-space: nowrap;">
                                        {{ formatTime(strike.time) }}
                                    </v-col>
                                    <v-col cols="4" class="text-center font-weight-bold text-orange-darken-1">
                                        {{ strike.dist }}<span class="text-caption ml-1">{{ stg.lightning.unit }}</span>
                                    </v-col>
                                    <v-col cols="4" class="text-right font-weight-bold text-white">
                                        {{ getDir(strike.bearing) }}
                                    </v-col>
                                </v-row>
                                <v-divider v-if="index < recentStrikes.length - 1"
                                    class="mt-1 border-bottom-dim"></v-divider>
                            </div>
                        </v-expansion-panel-text>
                    </v-expansion-panel>
                </v-expansion-panels>
            </div>

        </v-card-text>


        <div class="px-5 py-1 footer-bg border-top-dim rounded-b-lg">
            <div class="d-flex justify-space-between align-center text-caption font-weight-bold">
                <span class="text-orange" style="font-size: 0.7rem;">Area: {{ stg?.lightning.searchRadius }}{{
                    stg?.lightning.unit }}</span>
                <div :class="[(stg?.lightning.history.length > 0) ? 'text-green-accent-2' : 'text-grey-darken-1',
                    'd-flex align-center align-center justify-center mr-3']" style="font-size: 0.65rem;">
                    <v-icon icon="mdi-pulse" size="10" class="pulse-icon"></v-icon>
                    {{ lastUpdated }}
                </div>
                <span class="text-orange" style="font-size: 0.7rem;">Alert: {{ stg?.lightning.alertThreshold }}{{
                    stg?.lightning.unit }}</span>
            </div>
        </div>

    </v-sheet>
</template>

<script>
// import { globalState } from '../../state.js';
import { settings } from './dashboardSettings.js';
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
            shared: window.G_STATE,
            currentServerIndex: 0,
            connection: null,
            reconnectTimer: null,
            heartbeat: null,
            panel: null,
            instanceId: null
        };
    },
    created() {
        this.instanceId = Math.floor(Math.random() * 1000);
        console.log(`Component Created! ID: ${this.instanceId}`);
        if (this.stg.lightning.heartbeat) {
            console.log("Found an orphaned heartbeat in global state. Killing it now.");
            clearInterval(this.stg.lightning.heartbeat);
            this.stg.lightning.heartbeat = null;
        }
    },

    beforeUnmount() {
        if (this.stg.lightning.heartbeat) clearInterval(this.stg.lightning.heartbeat);
        if (this.reconnectTimer) clearTimeout(this.reconnectTimer);
        if (this.connection) this.connection.close();
    },

    mounted() {
        // 1. Cleanup
        if (this.freqTimer) clearInterval(this.freqTimer);
        if (this.expiryTimer) clearInterval(this.expiryTimer);

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

        // Init
        this.connect();
        this.thunderPlayer = new Audio('/sounds/thunder.mp3');
        this.thunderPlayer.load();
        this.updateFrequency();
        this.startExpiryTimer();

        // Schedule
        this.freqTimer = setInterval(() => {
            this.updateFrequency();
        }, 10000);
    },
    unmounted() {
        if (this.expiryTimer) clearInterval(this.expiryTimer);
        if (this.connection) this.connection.close();
    },
    watch: {
        // This watches the setting in dashboardSettings.js
        'stg.lightning.resetTime'(newVal) {
            console.log(`Setting changed to ${newVal}m. Sweeping history immediately.`);

            // Manual trigger of the pruning logic
            const cutoff = Date.now() - (newVal * 60 * 1000);
            this.stg.lightning.history = this.stg.lightning.history.filter(s => s.time > cutoff);
            this.stg.lightning.currentStorm.frequency = this.stg.lightning.history.length;
        }
    },
    methods: {
        lzw_decode(s) {
            let dict = {};
            let data = (s + "").split("");
            let currChar = data[0];
            let oldPhrase = currChar;
            let out = [currChar];
            let code = 256;
            let phrase;
            for (let i = 1; i < data.length; i++) {
                let currCode = data[i].charCodeAt(0);
                if (currCode < 256) {
                    phrase = data[i];
                } else {
                    phrase = dict[currCode] ? dict[currCode] : (oldPhrase + currChar);
                }
                out.push(phrase);
                currChar = phrase.charAt(0);
                dict[code] = oldPhrase + currChar;
                code++;
                oldPhrase = phrase;
            }
            return out.join("");
        },

        async connect() {
            try {

                const response = await fetch('/blitz-js');
                const scriptText = await response.text();
                const keyMatch = scriptText.match(/var\s+key\s*=\s*(\d+)/);

                if (!keyMatch) {
                    console.error("Could not find authorization key.");

                    setTimeout(() => this.connect(), 10000);
                    return;
                }

                this.authKey = Number(keyMatch[1]);
                console.log("Found Blitzortung Key:", this.authKey);

                this.establishConnection();
            } catch (err) {
                console.error("Connection failed:", err);
                setTimeout(() => this.connect(), 10000);
            }
        },

        establishConnection() {

            if (this.stg.lightning.heartbeat) clearInterval(this.stg.lightning.heartbeat);
            if (this.connection) {
                this.connection.onclose = null; // Prevent recursion
                this.connection.close();
            }
            const { lightning } = this.stg;
            const serverNum = lightning.wssServers[this.stg.lightning.currentServerIndex];
            // const wssUrl = `wss://ws${serverNum}.blitzortung.org`;
            const wssUrl = `wss://ws${serverNum}.blitzortung.org`;

            console.log(`Connecting to: ${wssUrl}`);
            this.connection = new WebSocket(wssUrl);

            this.connection.onopen = () => {
                console.log(`WebSocket connected to Server ${serverNum}`);

                setTimeout(() => {
                    if (this.connection.readyState === WebSocket.OPEN) {
                        const payload = JSON.stringify({ a: this.authKey });
                        this.connection.send(payload);
                        console.log(`Handshake SENT at ${new Date().toLocaleTimeString()}: ${payload}`);
                    }
                }, 1000);

                this.stg.lightning.heartbeat = setInterval(() => {
                    if (this.connection && this.connection.readyState === 1) {
                        const payload = JSON.stringify({ a: this.authKey });
                        this.connection.send(payload);
                        console.log(`Blitzortung Wss Heartbeat SENT at ${new Date().toLocaleTimeString()}: ${payload}`);
                    }
                }, 30000);
            };

            this.connection.onmessage = (event) => {
                try {
                    const decodedString = this.lzw_decode(event.data);
                    const raw = JSON.parse(decodedString);

                    const strike = {
                        lat: raw[1] || raw.la || raw.lat,
                        lon: raw[2] || raw.lo || raw.lon,
                        // Standardizing to ms for consistent math
                        time: Date.now()
                    };

                    if (strike.lat !== undefined && strike.lon !== undefined) {
                        // PASS TO THE GATEKEEPER
                        this.processIncomingStrike(strike);
                    }
                } catch (e) {
                    // Quietly catch parsing errors
                }
            };

            this.connection.onclose = () => {
                if (this.stg.lightning.heartbeat) clearInterval(this.stg.lightning.heartbeat);

                this.currentServerIndex = (this.currentServerIndex + 1) % this.lightning.wssServers.length;

                console.log(`Server ${serverNum} closed. Rotating to next server in 5s...`);
                setTimeout(() => this.establishConnection(), 5000);
            };

            this.connection.onerror = (err) => {
                console.error("WebSocket Error:", err);
                this.connection.close();
            };
        },

        processIncomingStrike(data) {
            if (!data || data.lat === undefined || data.lon === undefined) return;

            const now = Date.now();
            const home = this.stg.lightning?.homeLocation || { lat: 34.05, lon: -118.24 };
            const toRad = (v) => (v * Math.PI) / 180;
            const R = this.stg.lightning?.unit?.toLowerCase() === 'km' ? 6371 : 3958.8;

            // 1. Calculate Distance
            const dLat = toRad(data.lat - home.lat);
            const dLon = toRad(data.lon - home.lon);
            const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(toRad(home.lat)) * Math.cos(toRad(data.lat)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
            const dist = Math.round(R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)));

            // 2. THE GATEKEEPER
            // Only strikes within the Area (50Mi in your screenshot) get recorded
            if (dist <= this.stg.lightning.searchRadius) {

                // Calculate Bearing
                const y = Math.sin(toRad(data.lon - home.lon)) * Math.cos(toRad(data.lat));
                const x = Math.cos(toRad(home.lat)) * Math.sin(toRad(data.lat)) -
                    Math.sin(toRad(home.lat)) * Math.cos(toRad(data.lat)) * Math.cos(toRad(data.lon - home.lon));
                const bearing = Math.round((Math.atan2(y, x) * 180 / Math.PI + 360) % 360);

                // Record the strike
                this.stg.lightning.history.push({
                    time: data.time || now,
                    dist,
                    bearing
                });

                // 3. Update UI State
                this.stg.lightning.currentStorm.distance = dist;
                this.stg.lightning.currentStorm.bearing = bearing;

                // The frequency now accurately reflects history.length
                this.updateFrequency();
                this.playThunder();
                this.calculateTrend();

                // Auto-snap sample size logic
                // if (this.stg.lightning.isSnapped) {
                //     this.stg.lightning.sampleSize = Math.max(0.5, this.stg.lightning.history.length);
                // }

                console.log(`Local Strike: ${dist}mi @ ${bearing}°`);
            }
        },

        startExpiryTimer() {
            if (this.expiryTimer) clearInterval(this.expiryTimer);

            // Run a cleanup check every 10 seconds
            this.expiryTimer = setInterval(() => {
                const history = this.stg.lightning.history;
                if (!history.length) return;

                const now = Date.now();
                // Convert minutes (e.g., 5) to milliseconds
                const windowMs = (this.stg.lightning.resetTime || 30) * 60 * 1000;
                const cutoff = now - windowMs;

                // One line to filter
                this.stg.lightning.history = history.filter(s => s.time > cutoff);

                // If everything was just wiped out, reset the "Current Storm" display
                if (this.stg.lightning.history.length === 0) {
                    this.stg.lightning.currentStorm = { distance: 0, bearing: 0, trend: 'Stationary', frequency: 0 };
                    console.log("Cleanup: History expired. Dashboard reset.");
                }
            }, 10000);
        },

        toggleMute() {
            const newValue = !this.stg.lightning.isMuted;

            this.stg.lightning = {
                ...this.stg.lightning,
                isMuted: newValue
            };

            localStorage.setItem('lightning_config', JSON.stringify(this.stg.config));
        },

        openSettings() {
            // Sync the local modal state with the current global reactive state
            this.lightning = JSON.parse(JSON.stringify(this.stg.lightning));
            this.showModal = true;
        },

        saveSettings() {
            // 1. Update the global reactive state directly
            Object.assign(this.stg.lightning, this.lightning);

            // 2. Persist to localStorage so it survives a page refresh
            localStorage.setItem('lightning_config', JSON.stringify(this.stg.lightning));

            this.showModal = false;
            console.log("Settings saved and persisted.");
        },


        formatTime(ts) {
            if (!ts) return "--:--:--";
            const date = new Date(ts);
            return date.toLocaleTimeString('en-US', {
                hour12: true,
                hour: 'numeric',
                minute: '2-digit',
                second: '2-digit'
            });  //.replace(/\s/g, ''); // Removes the space before AM/PM for high density
        },

        getDir(b) {
            const sectors = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
            return sectors[Math.round((b || 0) / 22.5) % 16];
        },

        getTimeAgo(ts) {
            const seconds = Math.floor((Date.now() - ts) / 1000);
            if (seconds < 60) return "Just now";
            const minutes = Math.floor(seconds / 60);
            return minutes < 60 ? minutes + "m ago" : Math.floor(minutes / 60) + "h ago";
        },

        calculateTrend() {
            const h = this.stg.history;
            const config = this.stg.config;
            const sampleSize = Number(this.stg.lightning.sampleSize) || 20;
            const sensitivity = Number(this.lightning.sensitivity) || 2;

            if (h.length < sampleSize) {
                this.stg.lightning.currentStorm.trend = 'Stationary';
                return;
            }

            const window = h.slice(-sampleSize);
            let diff = 0;

            if (config.algorithm === 'Percentile (Balanced)') {
                // 1. Sort the current window by distance
                const sorted = [...window].sort((a, b) => a.dist - b.dist);
                // 2. Calculate the 20th percentile index
                const idx = Math.floor(0.2 * (sorted.length - 1));
                const currentRefDist = sorted[idx].dist;

                // 3. To find the trend, we compare this percentile to the previous one
                // (or compare the first half of the window vs the second half using percentiles)
                const mid = Math.floor(window.length / 2);
                const oldSorted = [...window.slice(0, mid)].sort((a, b) => a.dist - b.dist);
                const newSorted = [...window.slice(-mid)].sort((a, b) => a.dist - b.dist);

                const oldIdx = Math.floor(0.2 * (oldSorted.length - 1));
                const newIdx = Math.floor(0.2 * (newSorted.length - 1));

                diff = oldSorted[oldIdx].dist - newSorted[newIdx].dist;

            } else if (config.algorithm === 'Closest Strike (Fastest)') {
                diff = window[0].dist - window[window.length - 1].dist;
            } else {
                // Average (Smoother)
                const mid = Math.floor(window.length / 2);
                const oldAvg = window.slice(0, mid).reduce((a, b) => a + b.dist, 0) / mid;
                const newAvg = window.slice(-mid).reduce((a, b) => a + b.dist, 0) / mid;
                diff = oldAvg - newAvg;
            }

            // Apply Sensitivity Threshold
            if (diff > sensitivity) {
                this.stg.lightning.currentStorm.trend = 'Approaching';
            } else if (diff < -sensitivity) {
                this.stg.lightning.currentStorm.trend = 'Receding';
            } else {
                this.stg.lightning.currentStorm.trend = 'Stationary';
            }
        },



        updateFrequency() {
            const oneMinuteAgo = Date.now() - 60000;
            const radius = Number(this.stg.lightning.searchRadius || 1000);

            // We define 'localStrikes' here so the browser knows what it is
            const localStrikes = this.stg.lightning.history.filter(s => {
                return s.time > oneMinuteAgo && Number(s.dist) <= radius;
            });

            const freq = localStrikes.length;

            // Update the UI state
            this.stg.lightning.currentStorm.frequency = freq;

            // If you use a shared state object:
            if (this.shared?.lightning) {
                this.shared.lightning.frequency = freq;
            }
        },

        playThunder() {
            // Check the Gatekeeper
            if (this.stg.lightning.isMuted) {
                console.log("🔇 Mute is ON - skipping audio");
                return;
            }

            if (!this.thunderAudio) {
                this.thunderAudio = new Audio('/sounds/thunder.mp3');
            }

            this.thunderAudio.currentTime = 0;
            this.thunderAudio.play().catch(e => console.warn(e));
        },

        resetBuffer() {
            if (this.stg?.lightning.history) {
                this.stg.lightning.history = [];

                this.stg.lightning.currentStorm = {
                    distance: 0,
                    bearing: 0,
                    trend: 'Stationary',
                    frequency: 0
                };
            }
        },
        exportToDisk() {
            const dataStr = JSON.stringify(this.stg.config, null, 4);
            const blob = new Blob([dataStr], { type: 'application/json' });
            const url = URL.createObjectURL(blob);

            const link = document.createElement('a');
            link.href = url;
            link.download = `lightning-config-${new Date().toISOString().split('T')[0]}.json`;
            link.click();

            URL.revokeObjectURL(url);
            console.log("Configuration backed up to physical disk.");
        },
        importFromDisk(event) {
            const file = event.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = (e) => {
                try {
                    const importedConfig = JSON.parse(e.target.result);

                    this.stg.lightning = { ...this.stg.lightning, ...importedConfig };

                    this.localConfig = JSON.parse(JSON.stringify(this.stg.lightning));

                    localStorage.setItem('lightning_config', JSON.stringify(this.stg.lightning));

                    alert("Settings Restored Successfully!");
                } catch (err) {
                    console.error("Invalid JSON file:", err);
                    alert("Error: Failed to read the backup file.");
                }
            };
            reader.readAsText(file);
        },

        /* setThresholdFromCurrent() {
             if (this.stg.lightning.isSnapped) {
                 // RESTORE: Go back to exactly what we saved in the buffer
                 this.stg.lightning.sampleSize = this.stg.lightning.previousValue;
 
                 // --- ADD THIS LINE ---
                 this.stg.lightning.sampleSize = this.stg.lightning.sampleSize;
                 // ---------------------
 
                 this.stg.lightning.isSnapped = false;
             } else {
                 // SAVE: Store the current 2 (or whatever it is) before we snap
                 this.stg.lightning.previousValue = this.stg.lightning.sampleSize;
 
                 // SNAP: Set it to the current storm frequency
                 const currentFreq = this.stg?.lightning.currentStorm.frequency || 0;
                 this.stg.lightning.sampleSize = currentFreq;
                 this.stg.lightning.isSnapped = true;
 
                 this.stg.lightning.sampleSize = this.stg.lightning.sampleSize;
             }
         } */
    },
    computed: {
        // 1. Helper to make template code cleaner
        lightning() {
            return this.stg?.lightning || {};
        },

        // 2. The Time-Domain Sparkline logic
        sparklineValues() {
            const resetMinutes = this.stg.lightning.resetTime || 10;
            const now = Date.now();
            const windowMs = resetMinutes * 60 * 1000;
            const searchRadius = this.stg.lightning.searchRadius || 1000;

            const bucketCount = 60;
            const buckets = new Array(bucketCount).fill(0);

            if (this.stg.lightning.history && this.stg.lightning.history.length > 0) {
                this.stg.lightning.history.forEach(strike => {
                    let strikeTime = Number(strike.time);
                    if (strikeTime < 10000000000) strikeTime *= 1000;

                    const ageMs = now - strikeTime;

                    if (ageMs <= windowMs && ageMs >= -5000) {
                        const bucketIndex = Math.floor(((windowMs - ageMs) / windowMs) * (bucketCount - 1));

                        if (bucketIndex >= 0 && bucketIndex < bucketCount) {
                            let intensity = ((searchRadius - strike.dist) / searchRadius) * 100;
                            intensity = Math.max(20, intensity);

                            if (intensity > buckets[bucketIndex]) {
                                buckets[bucketIndex] = intensity;
                            }
                        }
                    }
                });
            }
            return buckets;
        },

        recentStrikes() {
            const history = this.lightning.history || [];
            const radius = this.lightning.searchRadius || 50;
            return [...history]
                .filter(strike => strike.dist <= radius)
                .reverse()
                .slice(0, 5);
        },

        // lastUpdated() {
        //     const history = this.lightning.history || [];
        //     const radius = this.lightning.searchRadius || 50;
        //     const localHistory = history.filter(h => h.dist <= radius);
        //     if (localHistory.length === 0) return 'No Local Strikes';
        //     const lastStrike = localHistory[localHistory.length - 1];
        //     return this.getTimeAgo(lastStrike.time);

        // },

        lastUpdated() {
            if (!this.lightning.history.length) return 'No Data';
            return this.getTimeAgo(this.lightning.history[this.lightning.history.length - 1].time);
        },

        convertedDistance() {
            const d = parseFloat(this.lightning.currentStorm?.distance);
            if (isNaN(d) || d === 0) return '0';
            return this.lightning.unit === 'Mi' ? Math.round(d) : Math.round(d * 1.60934);
        },

        trendColor() {
            const t = this.lightning.currentStorm?.trend;
            return t === 'Approaching' ? 'text-red-lighten-2' : (t === 'Receding' ? 'text-green-accent-2' : 'text-blue-lighten-3');
        },

        freqColor() {
            const f = this.lightning.currentStorm?.frequency || 0;
            if (f === 0) return 'grey-darken-3';
            return f < 10 ? 'blue-lighten-1' : (f < 20 ? 'orange-darken-1' : 'red-darken-2');
        },

        isMuted() {
            return this.stg.lightning.isMuted;
        },

        nearestActiveStrike() {
            if (!this.stg?.lightning?.history?.length) return null;
            return this.stg.lightning.history.reduce((prev, curr) =>
                prev.dist < curr.dist ? prev : curr
            );
        },
        // // Everything currently being tracked (The 1500mi net)
        // strikesInSearchRadius() {
        //     const radius = this.stg.lightning.searchRadius; // 1500
        //     return this.stg.lightning.buffer.filter(s => s.distance <= radius);
        // },

        // // Only the strikes that trigger the orange 'Caution' bar (The 25mi circle)
        // strikesInAlertRadius() {
        //     const threshold = this.stg.lightning.alertThreshold; // 25
        //     return this.strikesInSearchRadius.filter(s => s.distance <= threshold);
        // },

        // // This property controls if the Card Body is visible
        // hasDataToShow() {
        //     return this.strikesInSearchRadius.length > 0;
        // },

        // // This property controls if the Status Bar says 'Caution' or 'Clear'
        // isAlertActive() {
        //     return this.strikesInAlertRadius.length > 0;
        // }


    } // End of computed
};
</script>

<style scoped>
.lightning-card {
    border-radius: 0px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.header-bg {
    background: rgba(0, 0, 0, 0.3);
}

.footer-bg {
    background: rgba(0, 0, 0, 0.5);
}

.border-top-dim {
    border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.border-bottom-dim {
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.display-value {
    font-size: 3.5rem;
    font-weight: 900;
    line-height: 1;
    letter-spacing: -2px;
}

.unit-text {
    font-size: 1.2rem;
    color: rgba(255, 255, 255, 0.4);
}

.danger-banner {
    animation: danger-pulse 2s infinite;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
}

.pulse-icon {
    animation: pulse-animation 2s infinite;
}

.pulsing-icon {
    animation: pulse-lightning 1.5s infinite ease-in-out;
}

@keyframes danger-pulse {

    0%,
    100% {
        background-color: #d32f2f;
    }

    50% {
        background-color: #b71c1c;
    }
}

@keyframes pulse-animation {

    0%,
    100% {
        opacity: 1;
    }

    50% {
        opacity: 0.3;
    }
}

@keyframes pulse-lightning {

    0%,
    100% {
        transform: scale(1);
        filter: drop-shadow(0 0 0px #FFD54F);
    }

    50% {
        transform: scale(1.2);
        filter: drop-shadow(0 0 8px #FFD54F);
    }
}

.pulse-animation {
    animation: flash 2s infinite;
}

@keyframes flash {
    0% {
        opacity: 1;
    }

    50% {
        opacity: 0.4;
    }

    100% {
        opacity: 1;
    }
}

.time-col {
    white-space: nowrap;
    font-family: monospace;
    font-size: 0.85rem;
}

/* Tighten the expansion panel title */
:deep(.v-expansion-panel-title) {
    min-height: 32px !important;
    /* Forces it to be slimmer */
    padding: 0 8px !important;
    /* Standardize horizontal padding */
}

/* Adjust the icon (chevron) size if it feels too big now */
:deep(.v-expansion-panel-title__icon) {
    margin-inline-start: 4px !important;
    user-select: none;
}

/* Remove extra padding from the content area to keep it compact */
:deep(.v-expansion-panel-text__wrapper) {
    padding: 8px 12px 12px 12px !important;
}
</style>