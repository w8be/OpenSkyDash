# SkyDash

**A real-time dashboard for amateur radio.**

SkyDash brings local weather, lightning tracking, and solar indicies into a single browser-based interface. Run it locally on a Raspberry Pi.

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
- [Settings](#Settings)
- [Weather](#Weather)
- [Lightning](#Lightning)
- [Solar](#Solar)

---

## Dashboard Cards

SkyDash is built on selectable cards, each focused on a specific data source or function. Every card fetches its own data, manages its own refresh cycle. Below is a detailed walkthrough of each one.

---

### Header

The persistent bar at the top of the dashboard.

- **App Name** - A configurable name to display for your station.
- **Local Time** - Time indicator in hour, minutes and seconds that displays the current time for your locale.

---

### Dashboard Card icons

The persistent icons that provides at-a-glance information and card selection.

**From left to right:**

- **Weather** — Icon to open the Weather Card. The icon will update showing the current condition.
- **Lightning** — Icon to open the Lightning Card. The icon will flash in 1 second intervals when strikes are within the area or alert range.
- **Solar** — Icon to open the Solar Card. The icon will flash in 10 second intervals when (R)(S)(G) is > 0.
- **Settings** — Icon to open the Settings Card. All user configurable information is defined in this card. SkyDash is reactive and updates the cards upon unit change.

---

### Settings

Configurable data for SkyDash.

### General

- **App Name** - Name displayed on header. SkyDash is default.
- **Distance** - Mi/Km - Default is Mi
- **Pressure** - mb/in - Default is in
- **Temperature** - F/C - Default is F

- **Lat** - Latitude of your locale
- **Lon** - Longitude of your local

- **Reset Time** - Lighting Strike Buffer reset Time. Default is 5 minutes. Longer reset time utilizes additional memory recources.

- **Area Radius** - The radius where strikes within will display along with a warning banner. The default is 50.
- **Alert Radius** - The radius where strikes within will display aloing with the warning banner. The default is 25.

### Lightning_config

- **Calculation** - Method used to trend the strike path. Options are Closest, Average, or Percentile algorithms.
- **Sensitivity** - Value used to determine strike distance sensitivity. Higher values reduce trend flip-floping.
- **Sample Size** - Value used to determine the amount of strikes that are used in the trend calculations.

### Backup/Restore

- **Backup** - Creates a backup json file with the current settings in the $HOME/download directory (i.e.= SkyDash_station_settings.json)
- **Restore** - Load settings file from $/HOME/download directory (i.e= SkyDash_station_settings.json)

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

### Lightning

**Header from left to right:**

- Lightning Icon - Flashes when strikes occur in search area/alert radius.
- Strikes/minute Chip - Dynamic update of strikes per minute every 30 seconds.
- Mute Icon - Toggle audio off/on lightning strike.
- Trash Icon - Clear strike buffer on click.

**Banner**

- Visual coded alerts. Caution (Yellow), Warning (Red), or Quiet (Green)

**Distance / Direction / Trend**

- Distance from your locale to the strike. Values dynamically update to selected unit (Mi/Km).
- Brearing Indicator pointing to strike location.
- Compass heading. Headings are grouped into 16 bins(N, NNE, ENE)
- Trend - Approaching, Stationary, or Receding by compass heading.

**Sparkline**

- Visual representation of strike history. Strike amplitude is inversely proportional to distance. Closer strikes peak higher

**Recent Strikes**

- Expansion panel that shows the last 5 strikes
  - Time
  - Distance
  - Heading

**Footer**

- Area - Radius distance value. Any strikes <= this value will result in the Warning banner
- Strike Buffer Status - Last strike seen time when strikes in in the buffer. No Data when no strikes are in the area/alert radius
- Alert - Radius distance value. Any strikes <= to this value will result in the Danger banner. Trend calculation prioritized for strikes in the alert radius.

**How it works:** Lightning strikes within the search area/alert radius render on the card.

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

**Data source:** NOAA Space Weather Prediction Center (SWPC) and KC2G.com JSON feeds. Updates every 15 minutes.

---

## Health Dashboard

- **API** - `http://<localhost/ip>:5050/api/health` - The API will return the status, version, uptime, and fetch timestamp

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

**Kiosk install (kiosk mode — auto-starts fullscreen on boot):**

```bash

curl -sSL https://raw.githubusercontent.com/w8be/SkyDash/main/setup-pi.sh | bash -s --kiosk
```

The Pi boots directly into a fullscreen Chromium browser showing SkyDash. The kiosk launcher automatically detects Wayland (Trixie/labwc) or X11 (Bookworm/LXDE) and adjusts accordingly — no manual configuration needed. Only use this if you want a dedicated device for SkyDash.

**Server-only install (headless, no GUI):**

```bash

curl -sSL https://raw.githubusercontent.com/w8be/SkyDash/main/setup-pi.sh | bash -s --server
```

Runs SkyDash as a web server only. Access it from any browser on your LAN.

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

## Frequently Asked Questions

**Q: Do I need an amateur radio license to use SkyDash?**
A: No. SkyDash is a receive-only dashboard. Anyone can view DX spots, space weather, and POTA/WWFF activations. However, a callsign is needed for PSKReporter data (which tracks your transmitted signals) and for DX cluster login.

**Q: How much bandwidth does SkyDash use?**
A: Very little. All external API calls are cached server-side, and the backend serves compressed (gzip) responses. Typical usage is under 1 MB/minute. Most data sources update every 5–30 minutes.

**Q: Can I run this on a Raspberry Pi 3?**
A: Yes. The Pi 3B/3B+ works fine, though initial build time is slower (~5 minutes). A Pi 4 or 5 is recommended for the best experience. The server uses about 100–150 MB of RAM.

**Q: Can multiple people use the same server?**
A: Yes. The web interface is stateless — each browser session gets its own filter settings, theme preferences, and DX target. The server caches all API responses, so additional users add zero extra load on upstream services. For shared stations where operators want different layouts and configurations, use the **Profiles** feature (Settings → Profiles tab) to save and switch between named profiles.

**Q: Chromium shows a "keyring" unlock prompt on every boot in kiosk mode — how do I prevent it?**
A: This happens when Chromium tries to use the system keyring (gnome-keyring / kwallet) to protect its internal credential store, but the desktop session manager hasn't unlocked it yet. The Pi setup script already passes `--password-store=basic` to Chromium, which tells it to use a plain local store instead and avoids the prompt entirely. If you installed SkyDash before this fix was included, update your `kiosk.sh` by re-running the setup script, or add `--password-store=basic` manually to the Chromium launch line in `~/openhamclock/kiosk.sh`.

---

---

## License

MIT License — See [LICENSE](LICENSE) file.

---
