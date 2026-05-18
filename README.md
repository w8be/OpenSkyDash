# Station-Dashboard

**A real-time dashboard for amateur radio.**

Station-Dashboard brings local weather, lightning tracking, and solar indicies into a single browser-based interface. Run it locally on a Raspberry Pi.

**📝 License:** MIT — See [LICENSE](LICENSE)

---

### Prerequisites

- **Node.js v20.19 or later** (v22.12+ also supported) — required by Vite and the Express
  backend. The version of Node.js shipped by default in most Linux distributions
  (including Ubuntu 24.04 via `apt install nodejs`) is too old and **will not work**.

  Install a current LTS release using one of these methods:

  **NodeSource (Ubuntu / Debian — system-wide):**

  ```bash
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs
  ```

> ⚠️ **Ubuntu / Debian users:** Do **not** use `apt install nodejs` — the packaged version
> is v18 which is below the minimum required. Use NodeSource or nvm as shown above.

---

## Table of Contents

- [Deployment](#deployment)
  - [Raspberry Pi](#raspberry-pi)
- [Dashboard Cards](#dashboard-cards)
- [Header](#Header)
- [Dashboard Card Icons](#Dashboard-Card-Icons)
- [Weather](#Weather)
- [Lightning](#Lighting)
- [Solar](#Solar)

---

## Dashboard Cards

Station-Dashboard is built on selectable cards, each focused on a specific data source or function. Every card fetches its own data, manages its own refresh cycle. Below is a detailed walkthrough of each one.

---

### Header

The persistent bar at the top of the dashboard.

- **App Name** - A configurable name to display for your station.
- **Local Time** - Time indicator in hour, minutes and seconds that displays the current time for your locale.

---

### Dashboard Card icons

The persistent icons that provides at-a-glance information and card selection.

**From left to right:**

- **Weather** — Click on the icon to open the Weather Card. The icon will update showing the current condition.
- **Lightning** — Click on the icon to open the Lightning Card. The icon will flash when strikes are within the area or alert range.
- **Solar** — Click on the icon to open the Solar Card. The icon will flash when a Geomagnetic storm (g1-g5) is present.
- **Settings** — Click on the icon to open the Settings Card. All user configurable information is defined in this card.

---

### Weather

Current weather conditions at your station location.

**In the header:**

- Weather description icon and temperature in both °F and °C
- Last update time
- Feels like temperature in both °F and °C

**Current conditions icons**

- Wind speed in both mph/km
- Humidity
- Gusts in both mph/km
- Dew point in both °F and °C
- Air pressure in in/mb
- Cloud cover
- Visability in mph/km
- UV exposure

- **_Hover over the icon to show the label_**

**3 Day forecast**

- Day
- High/Low temperature
- Chance of rain

**How to use it:** The weather is shown automatically based on your configured station coordinates.

**Data sources:**

- **Open-Meteo** — Free weather API, no API key required. Fetched directly by each user's browser (rate limits are per-user, not per-server).

No configuration needed — weather works automatically based on your station coordinates.

**Refresh interval:** Every 15 minutes (weather data is cached server-side).

---

### Solar

Displays the three key solar indices that affect HF radio propagation. If you operate HF, these numbers directly determine what bands will be open.

**What it shows:**

- **SFI (Solar Flux Index)** — The 10.7 cm solar radio flux, measured daily at the Dominion Radio Astrophysical Observatory. This is the single most important number for HF propagation:
  - SFI < 70: Poor conditions, only lower bands (40m–160m) reliably open
  - SFI 70–100: Fair conditions, mid-bands (20m–30m) open
  - SFI 100–150: Good conditions, higher bands (15m–17m) opening
  - SFI > 150: Excellent conditions, 10m and 12m wide open
- **K-Index (Kp)** — Planetary geomagnetic disturbance level on a 0–9 scale. Lower is better for HF:
  - Kp 0–2 (green): Quiet — excellent HF conditions
  - Kp 3–4 (amber): Unsettled — noticeable degradation, especially on polar paths
  - Kp 5+ (red): Storm — significant HF disruption, possible blackouts on higher bands
- **SSN (Sunspot Number)** — Daily sunspot count from the Royal Observatory of Belgium. Correlates with the 11-year solar cycle. Higher SSN means more ionization and better HF conditions.
- **Band conditions summary** — An overall assessment combining SFI and Kp: EXCELLENT, GOOD, FAIR, or POOR.

**How to use it:** Check these numbers before getting on the air. High SFI + low Kp = good day for DX. The space weather values are also displayed in the header bar for quick reference without scrolling.

**Data source:** NOAA Space Weather Prediction Center (SWPC) JSON feeds. Updates every 5 minutes.

---

### Propagation Predictions

HF propagation reliability predictions between your station (DE) and whatever DX target you've selected on the map.

#### What it shows

- Per-band signal reliability as a percentage for each HF band
- Color-coded bars: green (>60% reliable), amber (30–60%), red (<30%)
- Predictions update automatically when you change your DX target on the map

#### How to use it

1. Click anywhere on the map to set a DX target location (or use the DX panel to enter coordinates).
2. The propagation panel recalculates predictions for the path between your station and that target.
3. Look for bands with high reliability percentages — those are your best bets for making contact.
4. Predictions change throughout the day as ionospheric conditions evolve, so check back periodically.

**Standard mode:** Uses a built-in propagation model based on current SFI, SSN, Kp, great-circle path distance, solar zenith angle, geomagnetic latitude, and estimated MUF (Maximum Usable Frequency) for each band.

**ITU-R P.533-14 predictions:** By default, all installs use the public Station-Dashboard ITURHFProp prediction service for ITU-R P.533-14 propagation calculations — the international standard for HF propagation prediction. If you prefer to self-host, deploy the optional ITURHFProp microservice (in the `iturhfprop-service/` directory) and set `ITURHFPROP_URL` in `.env` to your own instance.

**Hybrid correction:** When ionosonde data is available from `prop.kc2g.com`, the system applies real-time corrections based on actual measured ionospheric conditions rather than just modeled values. This can catch unusual propagation events that models miss.

**Data refresh:** Predictions update every 10 minutes.

#### Acknowledgement

Data gathered from `prop.kc2g.com` originates from the [Global Ionospheric Radio Observatory](https://giro.uml.edu) who have graciously offered free access for that purpose. Thanks are given to all of the [ionosonde stations participating in that network](https://giro.uml.edu/didbase/acknowledgements.html).

---

---

## Audio Alerts

Station-Dashboard can play audible tones when new items appear in data feeds — useful for monitoring while doing other tasks in the shack.

**Supported feeds:** POTA Spots, SOTA Spots, WWFF Spots, WWBOTA Spots, DX Cluster, DXpeditions, Contests.

**How to enable:**

1. Open **Settings** and click the **Alerts** tab.
2. Toggle any feed **ON** to enable audio alerts for that feed.
3. Select a tone from the dropdown — 9 Web Audio presets are available (Ping, High Ping, Low Tone, Sharp, Beep, Two-Tone, Simple, Chime, Chirp).
4. Click the speaker button to preview the selected tone.
5. Adjust the **Master Volume** slider to set the overall alert volume.

All feeds default to **OFF**. Settings persist in localStorage.

**Behavior notes:**

- Alerts are suppressed on initial page load (no noise from existing data).
- Alerts are suppressed for 5 seconds after returning to a background tab (prevents a flood of tones from stale data refreshing).
- A 10-second cooldown per feed prevents rapid-fire alerts from high-volume feeds like DX Cluster.
- One tone plays per batch of new items, not per individual item.
- Tones are generated via the Web Audio API — no sound files are downloaded.

---

---

## Settings

Save and switch between named configuration profiles. Useful when multiple operators share a single HamClock, or when you want to quickly toggle between different personal setups (contest mode, field day, everyday).

**What a profile captures:** Everything — your callsign, location, theme, layout, dock arrangement, map layers, DX filters, PSK filters, satellite filters, VOACAP preferences, temperature unit, time format, and all other `openhamclock_*` settings.

**How to use it:**

1. Open **Settings → Profiles** tab
2. Enter a name (e.g., your callsign, "Contest", "Field Day") and click **Save**
3. Your current state is captured as a named profile
4. To switch profiles, click **▶ Load** on any saved profile — the page reloads with that configuration
5. To update a profile with your current changes, click **↻** (update)
6. To share a profile or move it between devices, click **⤓** (export) to download a JSON file, then use **Import Profile from File** on the other device

**Profile actions:**

- **▶ Load** — Restores the profile and reloads the page
- **↻ Update** — Overwrites the saved profile with your current live state
- **✎ Rename** — Inline rename
- **⤓ Export** — Downloads as a `.json` file
- **✕ Delete** — With confirmation

Profiles are stored in your browser's localStorage. The currently active profile is shown with a green indicator.

---

## Auto-Refresh on Update

When the server is updated with a new version (e.g., via `git pull` + restart, or a Railway deployment), all connected browsers automatically detect the change and reload. There is nothing to configure.

**How it works:** The frontend polls `/api/version` every 60 seconds. When the returned version number changes, a toast notification appears at the bottom of the screen ("🔄 Station-Dashboard Updated — v15.0.0 → v15.1.0 — Reloading...") and the page reloads after 3 seconds. The version is read from `package.json` as the single source of truth.

---

## Health Dashboard

---

## Configuration Reference

All configuration is done through the `.env` file. On first run, this file is auto-created from `.env.example`. You can also change most settings through the browser-based Settings panel.

> **Can't find the `.env` file?** Files starting with a dot are hidden by default on Linux, Mac, and Raspberry Pi.
>
> - **Terminal:** `ls -la` to see hidden files, or `nano .env` to edit directly
> - **File manager (Pi/Linux):** Press `Ctrl+H` to toggle hidden files
> - **Mac Finder:** Press `Cmd+Shift+.` to toggle hidden files
> - **If the file doesn't exist yet:** Run `npm start` once and it will be auto-created, or copy it manually: `cp .env.example .env`
>
> The `.env` file is located in the root of your Station-Dashboard directory (same folder as `server.js` and `package.json`).

### Station Setting Variables

| Variable    | Default          | Description                                                                                                                               |
| ----------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `CALLSIGN`  | `N0CALL`         | Your amateur radio callsign. This is shown in the header bar and used for DX cluster login, PSKReporter queries, and "My Spots" tracking. |
| `LOCATOR`   | `FN31`           | Your Maidenhead grid locator (4 or 6 characters). Used to calculate your station coordinates if LATITUDE/LONGITUDE aren't set.            |
| `LATITUDE`  | _(from locator)_ | Station latitude in decimal degrees. Overrides the latitude calculated from LOCATOR.                                                      |
| `LONGITUDE` | _(from locator)_ | Station longitude in decimal degrees. Overrides the longitude calculated from LOCATOR.                                                    |

### Server Setting Variables

| Variable    | Default     | Description                                                                                                                              |
| ----------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `PORT`      | `3001`      | Backend API server port. In development, the Vite frontend runs on 3000 and proxies /api to this port.                                   |
| `HOST`      | `localhost` | Bind address. Set to `0.0.0.0` to make Station-Dashboard accessible from other devices on your LAN (tablets, phones, other PCs).         |
| `LOG_LEVEL` | `warn`      | Server log verbosity: `debug` (everything), `info` (operational), `warn` (problems), `error` (failures only). Use `warn` for production. |

### Display Preference Variables

| Variable      | Default     | Description                                                                                                                                                          |
| ------------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `UNITS`       | `imperial`  | `imperial` This setting is deprecated and no longer used.                                                                                                            |
| `DISTUNITS`   | `imperial`. | `imperial` (miles, inches, ...) or `metric (km, m, ...) For displaying anything involving a distance or speed.                                                       |
| `TEMPUNITS`   | `imperial`. | `imperial` (°F) or `metric` (°C). For displaying Temperatures.                                                                                                       |
| `PRESSUNITS`. | `imperial`  | `imperial` (inHg) or `metric` (hPa)                                                                                                                                  |
| `TIME_FORMAT` | `12`        | `12` or `24` hour clock format. Can also be toggled by clicking the local clock in the header.                                                                       |
| `THEME`       | `dark`      | `dark`, `light`, `legacy`, or `retro`. See [Themes and Layouts](#themes-and-layouts).                                                                                |
| `LAYOUT`      | `modern`    | `modern` or `classic`. See [Themes and Layouts](#themes-and-layouts).                                                                                                |
| `TZ`          | _(browser)_ | IANA timezone identifier (e.g., `America/New_York`, `Europe/London`). Only needed if your browser spoofs the timezone (common with privacy browsers like Librewolf). |

### Configuration Priority

Settings are loaded in this order (first match wins):

1. **localStorage** — Changes you make in the browser Settings panel are saved here and take top priority.
2. **.env file** — Your station configuration file. This is where you set your callsign and locator.
3. **Defaults** — Built-in fallback values (N0CALL, FN31, dark theme, modern layout).

Your `.env` file is never overwritten by updates, so your configuration is always safe.

---

## Deployment

### Raspberry Pi

One-line install for Raspberry Pi (3B, 3B+, 4, 5). Supports both graphical and headless operation.

**Supported operating systems:**

| OS                       | Debian | Status                 | Display              |
| ------------------------ | ------ | ---------------------- | -------------------- |
| Raspberry Pi OS Bookworm | 12     | ✅ Recommended         | X11 (openbox / LXDE) |
| Raspberry Pi OS Trixie   | 13     | ✅ Supported           | Wayland (labwc)      |
| Raspberry Pi OS Bullseye | 11     | ⚠️ Legacy, best-effort | X11                  |

**Standard install (kiosk mode — auto-starts fullscreen on boot):**

```bash

curl -H "Authorization: token <your_token>" -L [https://raw.githubusercontent.com/w8be/Station-Dashboard/main/setup-pi.sh](https://raw.githubusercontent.com/w8be/Station-Dashboard/main/setup.sh) | bash -s -- --kiosk
```

This is the recommended option for a dedicated shack display. The Pi boots directly into a fullscreen Chromium browser showing Station-Dashboard. The kiosk launcher automatically detects Wayland (Trixie/labwc) or X11 (Bookworm/LXDE) and adjusts accordingly — no manual configuration needed.

**Server-only install (headless, no GUI):**

```bash

curl -H "Authorization: token <your_token>" -L [https://raw.githubusercontent.com/w8be/Station-Dashboard/main/setup-pi.sh](https://raw.githubusercontent.com/w8be/Station-Dashboard/main/setup.sh) | bash -s -- --server
```

Runs Station-Dashboard as a web server only. Access it from any browser on your LAN.

**Standard install (manual browser launch):**

```bash
curl -fsSL https://raw.githubusercontent.com/accius/openhamclock/main/scripts/setup-pi.sh | bash
```

After installation, configure your station:

```bash
nano ~/openhamclock/.env              # Set CALLSIGN and LOCATOR
sudo systemctl restart openhamclock   # Apply changes
```

The setup script creates `.env` automatically from the built-in template and enables server-side settings sync (`SETTINGS_SYNC=true`) for Pi installs. This means your `CALLSIGN` and `LOCATOR` values from `.env` appear on screen as soon as the service restarts — no manual UI configuration step required.

The Pi setup script installs Node.js 22 LTS, clones the repository, builds the frontend, creates a systemd service (`openhamclock.service`) for automatic startup, and optionally configures Chromium in kiosk mode. It also installs `fonts-noto-color-emoji` so that all emoji icons display correctly in Chromium.

---

## Updating

### Git installations (local/Pi)

```bash
cd ~/openhamclock
./scripts/update.sh
```

The update script: backs up your `.env` → pulls latest code → installs new dependencies → rebuilds the frontend → restores your `.env`. Then restart:

```bash
sudo systemctl restart openhamclock
# or
./restart.sh
```

---

---

## Frequently Asked Questions

**Q: Do I need an amateur radio license to use Station-Dashboard?**
A: No. Station-Dashboard is a receive-only dashboard. Anyone can view DX spots, space weather, and POTA/WWFF activations. However, a callsign is needed for PSKReporter data (which tracks your transmitted signals) and for DX cluster login.

**Q: How much bandwidth does Station-Dashboard use?**
A: Very little. All external API calls are cached server-side, and the backend serves compressed (gzip) responses. Typical usage is under 1 MB/minute. Most data sources update every 5–30 minutes.

**Q: Can I run this on a Raspberry Pi 3?**
A: Yes. The Pi 3B/3B+ works fine, though initial build time is slower (~5 minutes). A Pi 4 or 5 is recommended for the best experience. The server uses about 100–150 MB of RAM.

**Q: Why don't I see any DX spots?**
A: Check that: (1) Your callsign is set in `.env` — the DX Spider proxy uses it to log in. (2) Your internet connection is working. (3) If using a custom `DXSPIDER_PROXY_URL`, make sure it's reachable. Check the server console for error messages.

**Q: Why does PSKReporter show no data?**
A: PSKReporter requires your callsign to be set correctly. If MQTT fails (some corporate firewalls block WebSocket connections), the system falls back to the HTTP API automatically. Check the panel footer to see which connection method is active.

**Q: Can multiple people use the same server?**
A: Yes. The web interface is stateless — each browser session gets its own filter settings, theme preferences, and DX target. The server caches all API responses, so additional users add zero extra load on upstream services. For shared stations where operators want different layouts and configurations, use the **Profiles** feature (Settings → Profiles tab) to save and switch between named profiles.

**Q: How do I change the DX cluster source?**
A: Open Settings → Station tab → DX Cluster Source dropdown. Or set `dxClusterSource` in the browser settings. The four options are: DX Spider Proxy (recommended), HamQTH, DXWatch, and Auto.

**Q: Can I use this with JTDX instead of WSJT-X?**
A: Yes. JTDX uses the same UDP protocol as WSJT-X. Configure JTDX's UDP settings the same way (address: `127.0.0.1`, port: `2237`).

**Q: Why are some POTA spots not on the map?**
A: A spot will appear in the panel list but not on the map if its coordinates couldn't be resolved. This is rare — the POTA API provides coordinates for almost all parks, and Station-Dashboard has a grid-square fallback for the rest.

**Q: How do I get the Classic layout to look like the original HamClock?**
A: Set `LAYOUT=classic` in `.env` (or select it in Settings). The Classic layout uses a black background with large colored number displays, matching the style of the original HamClock by WB0OEW.

**Q: I can't find the `.env` file — where is it?**
A: The `.env` file is in the root Station-Dashboard directory (same folder as `server.js`). Files starting with `.` are hidden by default — use `ls -la` in a terminal to see it, or `Ctrl+H` in a Linux file manager. If it doesn't exist yet, run `npm start` once (it's auto-created from `.env.example`) or copy it manually: `cp .env.example .env`. Most settings can also be changed through the browser Settings panel without editing `.env` at all.

**Q: Icons and emoji are showing as boxes or missing on Linux / Raspberry Pi — how do I fix it?**
A: Station-Dashboard uses emoji for icons throughout the interface (weather symbols, band indicators, satellite markers, and more). On Linux, emoji rendering depends on a color emoji font being installed on the **machine running the browser** — not the server. Install the Noto Color Emoji font to fix it:

```bash
sudo apt install fonts-noto-color-emoji
```

Then restart your browser (or reboot if running in kiosk mode). The Raspberry Pi setup script now installs this automatically. On Windows and macOS, emoji fonts are bundled with the OS and no action is needed.

**Q: Chromium shows a "keyring" unlock prompt on every boot in kiosk mode — how do I prevent it?**
A: This happens when Chromium tries to use the system keyring (gnome-keyring / kwallet) to protect its internal credential store, but the desktop session manager hasn't unlocked it yet. The Pi setup script already passes `--password-store=basic` to Chromium, which tells it to use a plain local store instead and avoids the prompt entirely. If you installed Station-Dashboard before this fix was included, update your `kiosk.sh` by re-running the setup script, or add `--password-store=basic` manually to the Chromium launch line in `~/openhamclock/kiosk.sh`.

---

---

## License

MIT License — See [LICENSE](LICENSE) file.

---

73 de K0CJH
[openhamclock.com](https://openhamclock.com) · [chris@cjhlighting.com](mailto:chris@cjhlighting.com)

```

```
