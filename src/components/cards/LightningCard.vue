<template>
    <!--  <pre>Local: {{ localConfig.sampleSize }}</pre> -->
    <!--  <v-card v-if="state?.currentStorm" class="mx-auto lightning-card bg-grey-darken-4"
    style="max-width: 300px; min-width:300px">  -->
    <v-sheet value="lightning" transition="fade-transition" flat class="mx-auto lightning-card bg-grey-darken-4"
        style="max-width: 300px; min-width:300px">

        <div class="d-flex justify-space-between align-center header-bg px-3 py-2"
            style="position: relative; z-index: 10;">
            <div class="d-flex align-center">
                <v-icon icon="mdi-flash" color="amber" size="large" class="mr-1"
                    :class="{ 'pulsing-icon': (state?.currentStorm?.frequency > 0) }">
                </v-icon>
                <div class="d-flex flex-column align-start">
                    <span class="text-subtitle-1 font-weight-bold text-brown-lighten-4"
                        style="line-height: 1.2rem;">Lightning</span>
                    <span class="text-grey-darken-1" style="font-size: 0.55rem;">Blitzortung.org</span>
                </div>
            </div>

            <div class="d-flex justify-space-between align-center">
                <v-chip size="x-small" :color="freqColor" variant="flat" class="font-weight-bold d-flex justify-center"
                    style="font-weight: bold; min-width: 65px;">
                    {{ state?.currentStorm?.frequency || 0 }}/min

                    <template v-slot:append>
                        <v-btn v-tooltip:top="'Chase Mode'" icon="mdi-radar" variant="text" size="x-small"
                            class="ml-2 ma-0" density="compact"
                            :color="localConfig.isSnapped ? 'cyan-accent-2' : 'grey-lighten-1'"
                            :class="{ 'ml-2 ma-0, pulse-animation': localConfig.isSnapped }"
                            @click="setThresholdFromCurrent"></v-btn>
                    </template>
                </v-chip>

                <div class="d-flex align-center">
                    <v-btn v-tooltip:top="'Mute'" icon variant="plain" size="small" @click="toggleMute" class="ma-0"
                        width="28">
                        <v-icon :icon="state?.config?.isMuted ? 'mdi-volume-off' : 'mdi-volume-high'"
                            :color="state?.config?.isMuted ? 'red' : 'green'" size="small">
                        </v-icon>
                    </v-btn>
                    <v-btn v-tooltip:top="'Clear Buffer'" icon variant="plain" size="small" @click="resetBuffer"
                        class="ma-0" width="28">
                        <v-icon icon="mdi-trash-can-outline"
                            :color="(state?.history?.length > 0) ? 'blue' : 'grey-darken-1'" size="small">
                        </v-icon>
                    </v-btn>
                    <v-btn v-tooltip:top="'Settings'" icon variant="plain" size="small" @click.stop="openSettings"
                        class="ma-0" width="28">
                        <v-icon icon="mdi-cog" color="grey-lighten-1" size="small"></v-icon>
                    </v-btn>
                </div>
            </div>
        </div>

        <template v-if="state?.config">
            <div v-if="state.currentStorm.distance > 0 && state.currentStorm.distance <= state.config.alertThreshold"
                class="danger-banner text-center py-1 font-weight-bold text-white" style="background-color: #d32f2f;">
                <v-icon icon="mdi-alert-octagon" size="x-small" class="mr-1"></v-icon>
                TAKE ACTION: Immediate Danger
            </div>
            <div v-else-if="state.currentStorm.distance > 0 && state.currentStorm.distance <= state.config.searchRadius"
                class="text-center py-1 font-weight-bold text-white" style="background-color: #c46300;">
                <v-icon icon="mdi-eye-check" size="x-small" class="mr-1"></v-icon>
                CAUTION: Strikes In Area
            </div>
            <div v-else class="text-center py-1 font-weight-bold text-white" style="background-color: #2e7d32;">
                <v-icon icon="mdi-shield-check" size="x-small" class="mr-1"></v-icon>
                STATUS: Clear / Monitoring
            </div>
        </template>

        <v-card-text v-if="state?.history && state.history.length > 0" class="pa-4">
            <div class="d-flex justify-space-between align-end mb-4">
                <div class="d-flex align-baseline">
                    <div class="display-value text-brown-lighten-4">{{ convertedDistance }}</div>
                    <div class="unit-text ml-1">{{ state.config?.unit }}</div>
                </div>
                <div class="text-right d-flex flex-column align-center" style="min-width: 100px;">
                    <v-icon icon="mdi-navigation"
                        :style="{ transform: `rotate(${state.currentStorm?.bearing || 0}deg)`, transition: 'transform 0.5s' }"
                        size="34" color="brown-lighten-4"></v-icon>
                    <div :class="['trend-text font-weight-black mt-1 text-capitalize', trendColor]">
                        {{ state.currentStorm?.trend }}
                    </div>
                    <div class="unit-text ml-1" style="font-size: 1.0rem;">
                        {{ getDir(state.currentStorm?.bearing) }}
                    </div>
                </div>
            </div>

            <v-sparkline :model-value="sparklineValues" :gradient="['#4caf50', '#ffeb3b', '#f44336']" smooth="10"
                line-width="3" height="50" fill padding="4">
            </v-sparkline>

            <v-expansion-panels v-model="panel" variant="accordion" class="mt-4 custom-panels">
                <v-expansion-panel class="bg-transparent" value="strikes">
                    <v-expansion-panel-title class="pa-0 text-capitalize text-caption font-weight-bold white--text">
                        Recent Strikes
                    </v-expansion-panel-title>
                    <v-expansion-panel-text>
                        <div v-for="(strike, index) in recentStrikes" :key="index" class="py-1">
                            <v-row no-gutters align="center" class="text-caption">
                                <v-col cols="4" class="text-left text-grey-lighten-1">{{ formatTime(strike.time)
                                    }}</v-col>
                                <v-col cols="5" class="text-center font-weight-bold text-orange-darken-1">{{ strike.dist
                                    }}{{
                                        state.config.unit }}</v-col>
                                <v-col cols="3" class="text-right font-weight-bold white--text">{{
                                    getDir(strike.bearing)
                                    }}</v-col>
                            </v-row>
                            <v-divider v-if="index < recentStrikes.length - 1"
                                class="mt-1 border-bottom-dim"></v-divider>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </v-card-text>

        <v-card-text v-else class="pa-10 text-center text-grey-darken-1">
            <v-icon icon="mdi-shield-check-outline" size="48" class="mb-2"></v-icon>
            <div class="text-caption font-weight-bold text-uppercase">Quiet</div>
        </v-card-text>

        <div class="px-5 py-1 footer-bg border-top-dim rounded-b-lg">
            <div class="d-flex justify-space-between align-center text-caption font-weight-bold">
                <span class="text-orange" style="font-size: 0.7rem;">Area: {{ state?.config?.searchRadius }}{{
                    state?.config?.unit }}</span>
                <div :class="[(state?.history.length > 0) ? 'text-green-accent-2' : 'text-grey-darken-1',
                    'd-flex align-center align-center justify-center mr-3']" style="font-size: 0.65rem;">
                    <v-icon icon="mdi-pulse" size="10" class="pulse-icon"></v-icon>
                    {{ lastUpdated }}
                </div>
                <span class="text-orange" style="font-size: 0.7rem;">Alert: {{ state?.config?.alertThreshold }}{{
                    state?.config?.unit }}</span>
            </div>
        </div>

        <v-dialog v-model="showModal" max-width="450" :key="showModal" eager>
            <v-card rounded="xl" class="pa-2">
                <v-layout style="display: block;">

                    <v-tabs v-model="activeTab" align-tabs="center">
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
                        <v-window v-model="activeTab">
                            <v-window-item value="general" style="height: 50vh; overflow-y: auto;">
                                <div class="text-subtitle-2 mb-2 text-secondary"><v-icon color="#d9d2e9"
                                        size="large">mdi-ruler</v-icon>
                                    Unit</div>
                                <v-btn-toggle v-model="localConfig.unit" mandatory color="orange-darken-2" class="mb-6">
                                    <v-btn value="Mi">Mi</v-btn>
                                    <v-btn value="Km">Km</v-btn>
                                </v-btn-toggle>

                                <div class="text-subtitle-2 mb-2 text-secondary"><v-icon size="large"
                                        color="#c8bba3">mdi-home-map-marker</v-icon>
                                    Location
                                </div>
                                <v-row density="comfortable" class="mb-2">
                                    <v-col class="text-info" cols="6"><v-text-field
                                            v-model.number="localConfig.homeLocation.lat" label="Lat" density="compact"
                                            variant="outlined"></v-text-field></v-col>
                                    <v-col class="text-info" cols="6"><v-text-field
                                            v-model.number="localConfig.homeLocation.lon" label="Lon" density="compact"
                                            variant="outlined"></v-text-field></v-col>
                                </v-row>

                                <div class="text-subtitle-2 mb-2 text-secondary"><v-icon size="large"
                                        color="#b06e69">mdi-clock-outline</v-icon>
                                    Reset
                                    Time
                                    ({{ localConfig.resetTime }})</div>
                                <v-btn-toggle v-model="localConfig.resetTime" mandatory color="blue" class="mb-6">
                                    <v-btn :value="5">5</v-btn>
                                    <v-btn :value="10">10</v-btn>
                                    <v-btn :value="30">30</v-btn>
                                    <v-btn :value="60">60</v-btn>
                                </v-btn-toggle>

                                <v-row density="comfortable">
                                    <v-col cols="6">
                                        <div class="text-subtitle-2 mb-1 text-secondary"><v-icon color="#4285F4"
                                                size="large">mdi-earth</v-icon>
                                            Area
                                        </div>
                                        <v-text-field class="text-info" v-model.number="localConfig.searchRadius"
                                            density="compact" variant="outlined"></v-text-field>
                                    </v-col>
                                    <v-col cols="6">
                                        <div class="text-subtitle-2 mb-1 text-secondary"><v-icon size="small"
                                                color="orange">mdi-lightning-bolt</v-icon> Alert</div>
                                        <v-text-field class="text-info" v-model.number="localConfig.alertThreshold"
                                            density="compact" variant="outlined"></v-text-field>
                                    </v-col>
                                </v-row>
                            </v-window-item>

                            <v-window-item value="tuning" style="height: 50vh; overflow-y: auto;">
                                <div class="text-overline text-orange mb-1">Trend</div>
                                <v-select v-model="localConfig.algorithm"
                                    :items="['Closest Strike (Fastest)', 'Average (Smoother)', 'Percentile (Balanced)']"
                                    variant="outlined" density="compact"></v-select>

                                <div class="text-overline text-orange mt-2">Sensitivity</div>

                                <v-slider class="mb-6" v-model="localConfig.sensitivity" min="0.5" max="10" step="0.5"
                                    color="orange" thumb-label="always" show-ticks="always" persistent-hint
                                    hint="Higher values reduce 'flip-flopping' of the trend">
                                    <template v-slot:append>
                                        <v-text-field v-model="localConfig.sensitivity" density="compact"
                                            style="width: 70px" variant="outlined" hide-details single-line
                                            type="number"></v-text-field>
                                    </template>
                                </v-slider>

                                <div class="text-overline text-orange mt-2">Sample Size</div>
                                <v-text-field v-model.number="localConfig.sampleSize" density="compact"
                                    variant="outlined" hide-details></v-text-field>

                                <div v-if="localConfig.algorithm === 'Percentile (Balanced)'"
                                    class="text-caption text-grey mt-1">
                                    Higher samples improve percentile accuracy (20th percentile).
                                </div>
                                <div v-else-if="localConfig.algorithm === 'Average (Smoother)'"
                                    class="text-caption text-grey mt-1">
                                    Higher samples dampen wild swings in trend.
                                </div>
                                <div v-else class="text-caption text-grey mt-1">
                                    Min strikes needed to calculate trend.
                                </div>

                                <div class="text-overline text-orange mt-6">Chase Mode</div>

                                <v-btn v-tooltip:top="'Chase Mode'" icon="mdi-radar" variant="text" size="x-large"
                                    density="compact" :color="localConfig.isSnapped ? 'cyan-accent-2' : 'grey-darken-1'"
                                    :class="['ml-2', { 'pulse-animation': localConfig.isSnapped }]"
                                    @click="setThresholdFromCurrent"></v-btn>

                                <div class="text-caption text-grey mt-1">
                                    Sync Sample Size to strike frequency
                                </div>
                            </v-window-item>

                            <v-window-item value="features" class="text-caption text-grey mt-1"
                                style="height: 70vh; overflow-y: auto;">
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
                </v-layout>

                <v-card-actions>
                    <v-btn variant="outlined" color="blue" size="small" @click="exportToDisk">Backup to File</v-btn>
                    <v-btn variant="outlined" color="green" size="small" @click="$refs.fileInput.click()">Restore from
                        File</v-btn>

                    <input type="file" ref="fileInput" style="display: none" @change="importFromDisk" accept=".json">

                    <v-spacer></v-spacer>
                    <v-btn variant="text" @click="showModal = false">Cancel</v-btn>
                    <v-btn color="orange-darken-2" variant="flat" @click="saveSettings">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-sheet>
</template>

<script>
export default {
    name: 'LightningCard',
    data() {
        return {
            state: {
                history: [],
                config: { searchRadius: 50, alertThreshold: 25, unit: 'Mi', isMuted: false, homeLocation: { lat: 0, lon: 0 }, resetTime: 30, sampleSize: 20 },
                currentStorm: { distance: 0, bearing: 0, trend: 'Stationary', frequency: 0 }
            },
            showModal: false,
            localConfig: {
                searchRadius: 50, alertThreshold: 25, unit: 'Mi',
                homeLocation: { lat: 0, lon: 0 }, resetTime: 30,
                sensitivity: 5,
                sampleSize: 5,
                previousValue: 5,
                isSnapped: false
            },
            calculationMethods: [
                'Closest Strike (Fastest)',
                'Average (Smoother)',
                'Percentile (Balanced)'
            ],
            activeTab: 'general',
            lastUnit: 'Mi',
            connection: null,
            panel: null,
            expiryTimer: null,
            connection: null,
            heartbeat: null,
            authKey: null,
            wssServers: [8, 7, 2, 1],
            currentServerIndex: 0
        };
    },
    watch: {
        'localConfig.unit': {
            handler(newUnit) {
                if (newUnit === this.lastUnit) return;
                const factor = 1.60934;
                const isToKm = newUnit.toLowerCase() === 'km';
                this.lastUnit = newUnit;
                this.localConfig.alertThreshold = isToKm ? Math.round(this.localConfig.alertThreshold * factor) : Math.round(this.localConfig.alertThreshold / factor);
                this.localConfig.searchRadius = isToKm ? Math.round(this.localConfig.searchRadius * factor) : Math.round(this.localConfig.searchRadius / factor);
            }
        }
    },
    mounted() {
        const saved = localStorage.getItem('lightning_config');
        if (saved) {
            try {
                const parsed = JSON.parse(saved);

                this.state.config = {
                    ...this.state.config,
                    ...parsed
                };

                this.localConfig = JSON.parse(JSON.stringify(this.state.config));
            } catch (e) {
                console.error("Failed to load settings:", e);
            }
        }

        this.connect();

        this.startExpiryTimer();

        this.freqTimer = setInterval(() => {
            this.updateFrequency();
        }, 10000);

        this.thunderPlayer = new Audio('/sounds/thunder.mp3');
        // Pre-load it so it's ready for the first strike
        this.thunderPlayer.load();
    },
    unmounted() {
        if (this.expiryTimer) clearInterval(this.expiryTimer);
        if (this.connection) this.connection.close();
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

            if (this.heartbeat) clearInterval(this.heartbeat);
            if (this.connection) {
                this.connection.onclose = null; // Prevent recursion
                this.connection.close();
            }

            const serverNum = this.wssServers[this.currentServerIndex];
            const wssUrl = `wss://ws${serverNum}.blitzortung.org`;

            console.log(`Connecting to: ${wssUrl}`);
            this.connection = new WebSocket(wssUrl);

            this.connection.onopen = () => {
                console.log(`WebSocket connected to Server ${serverNum}`);

                setTimeout(() => {
                    if (this.connection.readyState === WebSocket.OPEN) {
                        const payload = JSON.stringify({ a: this.authKey });
                        this.connection.send(payload);
                        console.log("Handshake SENT:", payload);
                    }
                }, 1000);

                this.heartbeat = setInterval(() => {
                    if (this.connection && this.connection.readyState === 1) {
                        const payload = JSON.stringify({ a: this.authKey });
                        this.connection.send(payload);
                        console.log("Heartbeat SENT:", payload);
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
                        time: Math.floor((raw.time || raw.t || Date.now()) / 1000000)
                    };

                    if (strike.lat !== undefined && strike.lon !== undefined) {
                        this.processIncomingStrike(strike);
                    }
                } catch (e) {
                }
            };

            this.connection.onclose = () => {
                if (this.heartbeat) clearInterval(this.heartbeat);

                this.currentServerIndex = (this.currentServerIndex + 1) % this.wssServers.length;

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
            const home = this.state.config.homeLocation || { lat: 0, lon: 0 };

            const toRad = (v) => (v * Math.PI) / 180;
            const R = this.state.config.unit?.toLowerCase() === 'km' ? 6371 : 3958.8;
            const dLat = toRad(data.lat - home.lat);
            const dLon = toRad(data.lon - home.lon);

            const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(toRad(home.lat)) * Math.cos(toRad(data.lat)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
            const dist = Math.round(R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)));

            if (dist <= this.state.config.searchRadius) {
                const y = Math.sin(toRad(data.lon - home.lon)) * Math.cos(toRad(data.lat));
                const x = Math.cos(toRad(home.lat)) * Math.sin(toRad(data.lat)) -
                    Math.sin(toRad(home.lat)) * Math.cos(toRad(data.lat)) * Math.cos(toRad(data.lon - home.lon));
                const bearing = Math.round((Math.atan2(y, x) * 180 / Math.PI + 360) % 360);

                this.state.history.push({ time: data.time || now, dist, bearing });
                this.state.currentStorm.distance = dist;
                this.state.currentStorm.bearing = bearing;

                if (dist <= this.state.config.alertThreshold) {
                    this.playThunder();
                }

                this.calculateTrend();
                this.updateFrequency();

                if (this.localConfig.isSnapped) {
                    const liveFreq = this.state.currentStorm.frequency || 0;
                    this.localConfig.sampleSize = Math.max(0.5, liveFreq);
                    this.state.config.sampleSize = this.localConfig.sampleSize;

                    // Check your browser console (F12) to see if this fires!
                    // console.log("SNAP ACTIVE - New SampleSize:", this.localConfig.sampleSize);
                }
            }
        },


        startExpiryTimer() {
            this.expiryTimer = setInterval(() => {
                if (this.state?.history?.length > 0) {
                    const limit = (this.state.config.resetTime || 30) * 60 * 1000;
                    const cutoff = Date.now() - limit;
                    this.state.history = this.state.history.filter(s => s && s.time > cutoff);
                }
            }, 30000);
        },

        toggleMute() {
            const newValue = !this.state.config.isMuted;

            this.state.config = {
                ...this.state.config,
                isMuted: newValue
            };

            localStorage.setItem('lightning_config', JSON.stringify(this.state.config));
        },

        openSettings() {
            // 1. Save your current Snap states so they don't get wiped
            const currentSnap = this.localConfig.isSnapped;
            const currentPrev = this.localConfig.previousValue;

            // 2. Load the global config as you were doing
            this.localConfig = JSON.parse(JSON.stringify(this.state.config));

            // 3. Restore the Snap states back into the new localConfig object
            this.localConfig.isSnapped = currentSnap;
            this.localConfig.previousValue = currentPrev;

            this.activeTab = 'general';
            this.showModal = true;
        },

        saveSettings() {
            const updated = {
                ...this.state.config,
                ...this.localConfig,
                searchRadius: Number(this.localConfig.searchRadius),
                alertThreshold: Number(this.localConfig.alertThreshold),
                sampleSize: Number(this.localConfig.sampleSize),
                sensitivity: Number(this.localConfig.sensitivity)
            };

            this.state.config = JSON.parse(JSON.stringify(updated));

            localStorage.setItem('lightning_config', JSON.stringify(this.state.config));

            this.showModal = false;
        },

        formatTime(ts) {
            return new Date(ts).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false });
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
            const h = this.state.history;
            const config = this.state.config;
            //    const sampleSize = Number(config.sampleSize) || 10;
            const sampleSize = Number(this.state.config.sampleSize) || 20;
            const sensitivity = Number(this.localConfig.sensitivity) || 2;

            if (h.length < sampleSize) {
                this.state.currentStorm.trend = 'Stationary';
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
                this.state.currentStorm.trend = 'Approaching';
            } else if (diff < -sensitivity) {
                this.state.currentStorm.trend = 'Receding';
            } else {
                this.state.currentStorm.trend = 'Stationary';
            }
        },

        updateFrequency() {
            const oneMinuteAgo = Date.now() - 60000;
            // Filter the history for anything that happened in the last 60 seconds
            const recentStrikes = this.state.history.filter(s => s.time > oneMinuteAgo);
            this.state.currentStorm.frequency = recentStrikes.length;
        },

        playThunder() {
            // Check the Gatekeeper
            if (this.state.config.isMuted) {
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
            if (this.state?.history) {
                this.state.history = [];

                this.state.currentStorm = {
                    distance: 0,
                    bearing: 0,
                    trend: 'Stationary',
                    frequency: 0
                };
            }

            this.send({
                topic: "session_reset",
                payload: "Manual reset triggered"
            });
        },
        exportToDisk() {
            const dataStr = JSON.stringify(this.state.config, null, 4);
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

                    this.state.config = { ...this.state.config, ...importedConfig };

                    this.localConfig = JSON.parse(JSON.stringify(this.state.config));

                    localStorage.setItem('lightning_config', JSON.stringify(this.state.config));

                    alert("Settings Restored Successfully!");
                } catch (err) {
                    console.error("Invalid JSON file:", err);
                    alert("Error: Failed to read the backup file.");
                }
            };
            reader.readAsText(file);
        },

        setThresholdFromCurrent() {
            if (this.localConfig.isSnapped) {
                // RESTORE: Go back to exactly what we saved in the buffer
                this.localConfig.sampleSize = this.localConfig.previousValue;

                // --- ADD THIS LINE ---
                this.state.config.sampleSize = this.localConfig.sampleSize;
                // ---------------------

                this.localConfig.isSnapped = false;
            } else {
                // SAVE: Store the current 2 (or whatever it is) before we snap
                this.localConfig.previousValue = this.localConfig.sampleSize;

                // SNAP: Set it to the current storm frequency
                const currentFreq = this.state?.currentStorm?.frequency || 0;
                this.localConfig.sampleSize = currentFreq;
                this.localConfig.isSnapped = true;

                this.state.config.sampleSize = this.localConfig.sampleSize;
            }
        }
    },
    computed: {
        sparklineValues() {
            return this.state.history.length ? this.state.history.map(h => 100 - h.dist) : [0, 0];
        },
        recentStrikes() {
            return [...this.state.history].reverse().slice(0, 5);
        },
        lastUpdated() {
            if (!this.state.history.length) return 'No Data';
            return this.getTimeAgo(this.state.history[this.state.history.length - 1].time);
        },
        trendColor() {
            const t = this.state.currentStorm.trend;
            return t === 'Approaching' ? 'text-red-lighten-2' : (t === 'Receding' ? 'text-green-accent-2' : 'text-blue-lighten-3');
        },
        freqColor() {
            const f = this.state.currentStorm.frequency;
            if (f === 0) return 'grey-darken-3';
            return f < 10 ? 'blue-lighten-1' : (f < 20 ? 'orange-darken-1' : 'red-darken-2');
        },
        isMuted() {
            return this.state.config.isMuted;
        },
        convertedDistance() {
            const unit = this.state.config.unit;
            const d = parseFloat(this.state.currentStorm.distance);

            if (isNaN(d)) return '--';

            const val = unit === 'Mi' ? d : (d * 1.60934);
            return Math.round(val);
        }
    }
};
</script>

<style scoped>
.lightning-card {
    border-radius: 12px;
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
    font-size: 4.0rem;
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
</style>