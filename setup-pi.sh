#!/bin/bash
#
# OpenSkyDash - Raspberry Pi Setup Script
#
# ═══════════════════════════════════════════════════════════════════
# SUPPORTED HARDWARE
# ═══════════════════════════════════════════════════════════════════
#
#   Raspberry Pi 3B / 3B+   (32-bit and 64-bit Raspberry Pi OS)
#   Raspberry Pi 4           (32-bit and 64-bit Raspberry Pi OS)
#   Raspberry Pi 5           (64-bit Raspberry Pi OS)
#
#   Other Debian-based ARM boards may work but are not tested.
#   Non-Raspberry Pi hardware will trigger a warning and prompt.
#
# ═══════════════════════════════════════════════════════════════════
# SUPPORTED OPERATING SYSTEMS
# ═══════════════════════════════════════════════════════════════════
#
#   Raspberry Pi OS Bookworm  (Debian 12)  — RECOMMENDED
#     Display server : X11 (openbox / LXDE)
#     Kiosk mode     : supported via xset + unclutter + Chromium
#     Boot config    : /boot/firmware/config.txt
#
#   Raspberry Pi OS Trixie    (Debian 13)  — SUPPORTED
#     Display server : Wayland (labwc) by default
#     Kiosk mode     : supported; X11 tools (xset, unclutter) are
#                      skipped automatically; Chromium is launched
#                      with --ozone-platform=wayland instead
#     Boot config    : /boot/firmware/config.txt
#
#   Raspberry Pi OS Bullseye  (Debian 11)  — LEGACY, best-effort
#     Display server : X11
#     Kiosk mode     : supported (same path as Bookworm)
#     Boot config    : /boot/config.txt
#     Note: Bullseye reached end-of-life. Upgrade is strongly advised.
#
# ═══════════════════════════════════════════════════════════════════
# NOT SUPPORTED / OUT OF SCOPE
# ═══════════════════════════════════════════════════════════════════
#
#   • Ubuntu, Manjaro, Fedora, or other non-Raspberry Pi OS distros
#     (different package names, init systems, and display setups)
#   • Raspberry Pi OS Buster (Debian 10) or older
#     (Node 22 LTS is not available via NodeSource for Buster)
#   • Headless-only Pi Zero / Pi Zero 2 W in kiosk mode
#     (--server mode works; --kiosk requires a display)
#   • Windows / macOS / generic x86-64 Linux
#     (see scripts/setup-linux.sh for Linux desktop installs)
#
# ═══════════════════════════════════════════════════════════════════
# PREREQUISITES
# ═══════════════════════════════════════════════════════════════════
#
#   • A clean or up-to-date Raspberry Pi OS install
#   • Internet access during setup (NodeSource, apt, npm, GitHub)
#   • sudo privileges for the running user
#   • At least 1 GB free disk space (build artefacts + node_modules)
#   • At least 512 MB RAM (1 GB+ recommended for the npm build step)
#
# ═══════════════════════════════════════════════════════════════════
# WHAT THIS SCRIPT DOES
# ═══════════════════════════════════════════════════════════════════
#
#   1. Updates system packages (apt-get update && upgrade)
#   2. Installs Node.js 22 LTS via NodeSource
#   3. Installs system dependencies (Chromium, fonts, display tools)
#   4. Clones or updates the OpenSkyDash repository
#   5. Runs npm install and npm run build
#   6. Creates /home/<user>/.env from .env.example (if absent)
#   7. Creates and enables a systemd service (OpenSkyDash.service)
#   8. [--kiosk] Writes kiosk.sh that auto-detects Wayland vs X11
#      and launches Chromium in fullscreen on login
#
# ═══════════════════════════════════════════════════════════════════
# KIOSK MODE DETAILS
# ═══════════════════════════════════════════════════════════════════
#
#   The kiosk launcher (~OpenSkyDash/kiosk.sh) is placed in
#   ~/.config/autostart/ and runs on every desktop login.
#
#   At runtime kiosk.sh reads $XDG_SESSION_TYPE to choose the
#   correct display path:
#
#     Wayland  →  Chromium launched with --ozone-platform=wayland
#                 xset / unclutter are NOT called (X11-only tools)
#
#     X11      →  DISPLAY=:0 is set explicitly (not always inherited
#                 from the autostart context), then xset disables the
#                 screensaver and unclutter hides the cursor
#
#   If the OpenSkyDash server does not respond within 60 seconds,
#   kiosk.sh exits with an error rather than looping forever.
#
# ═══════════════════════════════════════════════════════════════════
# USAGE
# ═══════════════════════════════════════════════════════════════════
#
#   chmod +x setup-pi.sh
#   ./setup-pi.sh               # server only (no kiosk)
#   ./setup-pi.sh --kiosk       # server + fullscreen kiosk on boot
#   ./setup-pi.sh --server      # headless server, no GUI packages
#   ./setup-pi.sh --help        # show option summary
#
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

INSTALL_DIR="$HOME/OpenSkyDash"
SERVICE_NAME="OpenSkyDash"
NODE_VERSION="22"

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗";
echo "║                                                            ║";
echo "║███████╗██╗  ██╗██╗   ██╗██████╗  █████╗ ███████╗██╗  ██╗   ║";
echo "║██╔════╝██║ ██╔╝╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██║  ██║   ║";
echo "║███████╗█████╔╝  ╚████╔╝ ██║  ██║███████║███████╗███████║   ║";
echo "║╚════██║██╔═██╗   ╚██╔╝  ██║  ██║██╔══██║╚════██║██╔══██║   ║";
echo "║███████║██║  ██╗   ██║   ██████╔╝██║  ██║███████║██║  ██║   ║";
echo "║╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ║";
echo "║                                                            ║";
echo "║   Raspberry Pi Setup Script                                ║";
echo "║                                                            ║";
echo "╚════════════════════════════════════════════════════════════╝";
echo -e "${NC}"                                                         

SERVER_MODE=true
KIOSK_MODE=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --kiosk) KIOSK_MODE=true SERVER_MODE=false ;;
        --server) SERVER_MODE=true KIOSK_MODE=false ;;
        --help) 
            echo "Usage: ./setup-pi.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --kiosk     Enable kiosk mode (fullscreen, auto-start)"
            echo "  --server    Install as headless server only"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

check_raspberry_pi() {
    if [ -f /proc/device-tree/model ]; then
        MODEL=$(cat /proc/device-tree/model)
        echo -e "${GREEN}✓ Detected: $MODEL${NC}"
    else
        echo -e "${YELLOW}⚠ Warning: This doesn't appear to be a Raspberry Pi${NC}"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

update_system() {
    echo -e "${BLUE}>>> Updating system packages...${NC}"
    sudo apt-get update -qq

    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq \
        -o Dpkg::Options::="--force-confold" \
        -o Dpkg::Options::="--force-confdef"
}

install_nodejs() {
    echo -e "${BLUE}>>> Installing Node.js ${NODE_VERSION}...${NC}"

    if command -v node &> /dev/null; then
        CURRENT_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$CURRENT_VERSION" -ge "$NODE_VERSION" ]; then
            echo -e "${GREEN}✓ Existing Node.js v$CURRENT_VERSION detected. Skipping install to protect existing apps.${NC}"
            return
        fi
    fi

    ARCH=$(dpkg --print-architecture 2>/dev/null || uname -m)

    if [ "$ARCH" = "armhf" ]; then

        echo -e "${YELLOW}⚠ 32-bit ARM (armhf) detected — NodeSource does not support this architecture.${NC}"
        echo -e "${BLUE}  Downloading official Node.js ${NODE_VERSION} armv7l binary from nodejs.org...${NC}"

        NODE_DIST_BASE="https://nodejs.org/dist/latest-v${NODE_VERSION}.x"
        NODE_TARBALL=$(curl -fsSL "$NODE_DIST_BASE/" \
            | grep -o "node-v[0-9.]*-linux-armv7l\.tar\.gz" \
            | head -1)

        if [ -z "$NODE_TARBALL" ]; then
            echo -e "${RED}✗ Could not locate a Node.js ${NODE_VERSION} armv7l release on nodejs.org.${NC}"
            exit 1
        fi

        echo -e "${BLUE}  Installing $NODE_TARBALL ...${NC}"
        NODE_TMPFILE=$(mktemp /tmp/nodejs-armv7l-XXXXXX.tar.gz)
        curl -fsSL \
            --retry 3 --retry-delay 5 --retry-connrefused \
            "$NODE_DIST_BASE/$NODE_TARBALL" \
            -o "$NODE_TMPFILE" || {
            rm -f "$NODE_TMPFILE"
            echo -e "${RED}✗ Failed to download Node.js armv7l binary (tried 3 times).${NC}"
            exit 1
        }
        sudo tar -xz -C /usr/local --strip-components=1 -f "$NODE_TMPFILE" || {
            rm -f "$NODE_TMPFILE"
            echo -e "${RED}✗ Failed to extract Node.js armv7l binary.${NC}"
            exit 1
        }
        rm -f "$NODE_TMPFILE"
    else

        curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash - || {
            echo -e "${RED}✗ NodeSource setup failed. Check your Debian version and internet connection.${NC}"
            exit 1
        }
        sudo apt-get install -y nodejs
    fi

    echo -e "${GREEN}✓ Node.js $(node -v) installed${NC}"
}

install_dependencies() {
    echo -e "${BLUE}>>> Installing system dependencies...${NC}"
    
    PACKAGES="git fonts-noto-color-emoji"
    
    if [ "$SERVER_MODE" = false ]; then
        PACKAGES="$PACKAGES unclutter x11-xserver-utils"
        if apt-cache show chromium &>/dev/null; then
            PACKAGES="$PACKAGES chromium"
        else
            PACKAGES="$PACKAGES chromium-browser"
        fi
    fi
    
    sudo apt-get install -y -qq $PACKAGES
    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

setup_repository() {    
    echo -e "${BLUE}>>> Setting up OpenSkyDash...${NC}"

    if [ ! -f /swapfile ]; then
        echo -e "${BLUE}>>> Creating temporary swap for build...${NC}"
        sudo fallocate -l 1G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
    fi
    
    if [ -d "$INSTALL_DIR" ]; then
        echo "Updating existing installation..."
        cd "$INSTALL_DIR"
        git pull
    else
        echo "Cloning repository..."
        git clone https://github.com/w8be/OpenSkyDash.git "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
    
    git config core.fileMode false 2>/dev/null
    
    ELECTRON_SKIP_BINARY_DOWNLOAD=1 npm install --include=dev --ignore-scripts

    echo -e "${BLUE}>>> Downloading vendor assets for privacy...${NC}"
    bash scripts/vendor-download.sh || echo -e "${YELLOW}⚠ Vendor download failed — will fall back to CDN${NC}"

    npm install
    npm run build

    if [ -f /swapfile ]; then
        sudo swapoff /swapfile
        sudo rm /swapfile
    fi

    echo -e "${GREEN}✓ OpenSkyDash installed to $INSTALL_DIR${NC}"
}

create_service() {
    echo -e "${BLUE}>>> Creating systemd service...${NC}"

    NODE_BIN=$(command -v node)
    if [ -z "$NODE_BIN" ]; then
        echo -e "${RED}✗ Cannot find node binary — Node.js installation may have failed.${NC}"
        exit 1
    fi
    echo -e "${GREEN}  Using node at: $NODE_BIN${NC}"

    sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null << EOF
[Unit]
Description=OpenSkyDash Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$NODE_BIN server.js
Restart=always
RestartSec=10
SuccessExitStatus=75
Environment=NODE_ENV=production
# PORT is read from .env; set here only as a fallback so the service always
# has a defined value even if .env is missing or PORT is not set there.
Environment=PORT=5050

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable ${SERVICE_NAME}
    sudo systemctl start ${SERVICE_NAME}
    
    echo -e "${GREEN}✓ Service created and started${NC}"
}

setup_kiosk() {
    echo -e "${BLUE}>>> Configuring kiosk mode...${NC}"
    
    sudo raspi-config nonint do_blanking 0 2>/dev/null || true
    
    mkdir -p "$HOME/.config/autostart"

    cat > "$INSTALL_DIR/kiosk.sh" << 'EOF'
#!/bin/bash
# OpenSkyDash Kiosk Launcher
# Supports Raspberry Pi OS Bookworm (X11) and Trixie (Wayland/labwc)

# Wait for the desktop environment to be ready
sleep 5

# ------------------------------------------------------------------
# Detect display server: Wayland or X11
# $XDG_SESSION_TYPE is set by the session manager on both Bookworm and Trixie.
# Fall back to checking $WAYLAND_DISPLAY in case the variable isn't exported.
# ------------------------------------------------------------------
SESSION_TYPE="${XDG_SESSION_TYPE:-}"
if [ -z "$SESSION_TYPE" ] && [ -n "$WAYLAND_DISPLAY" ]; then
    SESSION_TYPE="wayland"
fi
if [ -z "$SESSION_TYPE" ]; then
    # Last resort: default to x11 so the script always does something useful
    SESSION_TYPE="x11"
fi

echo "OpenSkyDash kiosk: detected session type = $SESSION_TYPE"

if [ "$SESSION_TYPE" = "wayland" ]; then
    # ------------------------------------------------------------------
    # Wayland path (Raspberry Pi OS Trixie with labwc)
    # xset and unclutter require an X server — skip them entirely.
    # Screen blanking is disabled system-wide via raspi-config at install time.
    # ------------------------------------------------------------------
    CHROMIUM_EXTRA_FLAGS="--ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations"
else
    # ------------------------------------------------------------------
    # X11 path (Raspberry Pi OS Bookworm with openbox/LXDE)
    # DISPLAY=:0 must be set explicitly — it is not always inherited when
    # the script is launched from an XDG autostart .desktop file.
    # ------------------------------------------------------------------
    export DISPLAY="${DISPLAY:-:0}"

    # Disable screen saver and power management
    xset s off    2>/dev/null || true
    xset -dpms    2>/dev/null || true
    xset s noblank 2>/dev/null || true

    # Hide mouse cursor after 1 second of inactivity
    unclutter -idle 1 -root &

    CHROMIUM_EXTRA_FLAGS=""
fi

# ------------------------------------------------------------------
# Wait for the OpenSkyDash server to be ready (max 60 seconds)
# ------------------------------------------------------------------
MAX_WAIT=60
WAITED=0
until curl -s "$HEALTH_URL" > /dev/null 2>&1; do
    if [ "$WAITED" -ge "$MAX_WAIT" ]; then
        echo "ERROR: OpenSkyDash server did not respond within ${MAX_WAIT}s."
        echo "Check the service: sudo systemctl status OpenSkyDash"
        exit 1
    fi
    sleep 1
    WAITED=$((WAITED + 1))
done
echo "Server ready after ${WAITED}s."

# ------------------------------------------------------------------
# Choose Chromium binary
# 'chromium' on Bookworm+, 'chromium-browser' on older images
# ------------------------------------------------------------------
if command -v chromium &> /dev/null; then
    CHROME_CMD="chromium"
else
    CHROME_CMD="chromium-browser"
fi

# ------------------------------------------------------------------
# Clear stale crash-recovery prompts from unclean shutdowns
# Prevents the "Chromium didn't shut down correctly" bar in kiosk mode
# ------------------------------------------------------------------
KIOSK_PROFILE="$HOME/.config/OpenSkyDash-kiosk"
mkdir -p "$KIOSK_PROFILE"
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' "$KIOSK_PROFILE/Default/Preferences" 2>/dev/null || true
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$KIOSK_PROFILE/Default/Preferences" 2>/dev/null || true

# ------------------------------------------------------------------
# Launch Chromium in kiosk mode
# ------------------------------------------------------------------
trap 'pkill -f "chromium.*kiosk"; exit 0' SIGTERM SIGINT

# shellcheck disable=SC2086  # CHROMIUM_EXTRA_FLAGS is intentionally word-split
$CHROME_CMD \
    --kiosk \
    --noerrdialogs \
    --disable-infobars \
    --disable-session-crashed-bubble \
    --disable-restore-session-state \
    --disable-features=TranslateUI \
    --check-for-update-interval=31536000 \
    --disable-component-update \
    --overscroll-history-navigation=0 \
    --disable-pinch \
    --password-store=basic \
    --user-data-dir="$HOME/.config/OpenSkyDash-kiosk" \
    $CHROMIUM_EXTRA_FLAGS \
    http://localhost:5050 &

CHROME_PID=$!

echo "OpenSkyDash kiosk running (PID: $CHROME_PID)"
echo "Exit methods:"
echo "  - Alt+F4        (close Chromium)"
echo "  - Ctrl+Alt+T    (open terminal, then: pkill -f kiosk)"
echo "  - SSH in and run: pkill -f kiosk.sh"

wait $CHROME_PID
EOF
    
    chmod +x "$INSTALL_DIR/kiosk.sh"

    cat > "$HOME/.config/autostart/OpenSkyDash-kiosk.desktop" << EOF
[Desktop Entry]
Type=Application
Name=OpenSkyDash Kiosk
Exec=$INSTALL_DIR/kiosk.sh
Hidden=false
X-GNOME-Autostart-enabled=true
EOF
    

    if [ -f /boot/firmware/config.txt ]; then
        BOOT_CONFIG=/boot/firmware/config.txt
    elif [ -f /boot/config.txt ]; then
        BOOT_CONFIG=/boot/config.txt
    else
        BOOT_CONFIG=""
    fi

    if [ -n "$BOOT_CONFIG" ]; then
        if ! grep -q "disable_splash=1" "$BOOT_CONFIG"; then
            echo "disable_splash=1" | sudo tee -a "$BOOT_CONFIG" > /dev/null
        fi

        if ! grep -q "gpu_mem=" "$BOOT_CONFIG"; then
            echo "gpu_mem=128" | sudo tee -a "$BOOT_CONFIG" > /dev/null
        fi
    else
        echo -e "${YELLOW}⚠ Boot config not found — skipping gpu_mem and splash settings${NC}"
    fi
    
    echo -e "${GREEN}✓ Kiosk mode configured${NC}"
}

create_scripts() {
    echo -e "${BLUE}>>> Creating helper scripts...${NC}"
    
    cat > "$INSTALL_DIR/start.sh" << EOF
#!/bin/bash
cd "$INSTALL_DIR"
node server.js
EOF
    chmod +x "$INSTALL_DIR/start.sh"
    
    cat > "$INSTALL_DIR/stop.sh" << EOF
#!/bin/bash
sudo systemctl stop ${SERVICE_NAME}
pkill -f chromium 2>/dev/null || true
pkill -f unclutter 2>/dev/null || true
echo "OpenSkyDash stopped"
EOF
    chmod +x "$INSTALL_DIR/stop.sh"
    
    cat > "$INSTALL_DIR/restart.sh" << EOF
#!/bin/bash
sudo systemctl restart ${SERVICE_NAME}
echo "OpenSkyDash restarted"
EOF
    chmod +x "$INSTALL_DIR/restart.sh"
    
    cat > "$INSTALL_DIR/status.sh" << EOF
#!/bin/bash
echo "=== OpenSkyDash Status ==="
sudo systemctl status ${SERVICE_NAME} --no-pager
echo ""
EOF
    chmod +x "$INSTALL_DIR/status.sh"
    
    echo -e "${GREEN}✓ Helper scripts created${NC}"
}

deploy_dashboard() {
    echo -e "${BLUE}>>> Deploying OpenSkyDash Dashboard...${NC}"

    cd /home/w8be/OpenSkyDash || { echo -e "${RED}✗ Directory not found${NC}"; return; }

    echo -e "${BLUE}    Installing Node modules...${NC}"
    npm install --quiet

    echo -e "${BLUE}    Building production assets (Vite)...${NC}"
    npm run build

    echo -e "${BLUE}    Setting up Systemd Service...${NC}"

    sudo systemctl daemon-reload
    sudo systemctl enable OpenSkyDash
    sudo systemctl restart OpenSkyDash

    echo -e "${GREEN}✓ Dashboard deployed and running on port 5050${NC}"
}

print_summary() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Installation Complete!                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${BLUE}Installation Directory:${NC} $INSTALL_DIR"
    IP_ADDR=$(hostname -I | awk '{print $1}')
    
    echo -e "  ${BLUE}Web Interface (Local):${NC}  http://localhost:5050"
    echo -e "  ${BLUE}Web Interface (Network):${NC} http://$IP_ADDR:5050"
    echo -e "  ${BLUE}Web Interface (MDNS):${NC}    http://$(hostname).local:5050"
    echo ""
    echo ""
    echo -e "  ${YELLOW}Service Commands:${NC}"
    echo "    sudo systemctl start ${SERVICE_NAME}"
    echo "    sudo systemctl stop ${SERVICE_NAME}"
    echo "    sudo systemctl status ${SERVICE_NAME}"
    echo "    sudo journalctl -u ${SERVICE_NAME} -f"
    echo ""
    
    if [ "$KIOSK_MODE" = true ]; then
        echo -e "  ${GREEN}Kiosk Mode:${NC} Enabled"
        echo "    OpenSkyDash will auto-start on boot in fullscreen"
        echo ""
        echo -e "    ${YELLOW}Exit kiosk:${NC}"
        echo "      Alt+F4          Close Chromium"
        echo "      Ctrl+Alt+T      Open terminal (then: pkill -f kiosk)"
        echo "      SSH:            pkill -f kiosk.sh"
        echo ""
        echo -e "    ${YELLOW}Disable auto-start:${NC}"
        echo "      rm ~/.config/autostart/OpenSkyDash-kiosk.desktop"
        echo ""
    fi
    
    echo -e "  ${BLUE}73 de OpenSkyDash!${NC}"
    echo ""
    
    if [ "$KIOSK_MODE" = true ]; then
        read -p "Reboot now to start kiosk mode? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo reboot
        fi
    fi
}

main() {
    check_raspberry_pi
    update_system
    install_nodejs
    install_dependencies
    setup_repository
    create_service
    create_scripts
    deploy_dashboard
    
    if [ "$KIOSK_MODE" = true ]; then
        setup_kiosk
    fi
    
    print_summary
}

main