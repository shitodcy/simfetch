#!/bin/bash

# --- SKEMA WARNA: Catppuccin Mocha ---
ROSEWATER='\033[38;2;245;224;220m'
FLAMINGO='\033[38;2;242;205;205m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
RED='\033[38;2;243;139;168m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT1='\033[38;2;186;194;222m'
OVERLAY2='\033[38;2;147;153;178m'
NC='\033[0m'
# ----------------------------------------

# --- IKON + LABEL (NERD FONTS) ---
LBL_DISTRO="${SKY}󰌖 Distro${NC}"
LBL_KERNEL="${PEACH}󰌢 Kernel${NC}"
LBL_UPTIME="${YELLOW}󰔟 Uptime${NC}"
LBL_DE="${PINK}󰍺 DE${NC}"
LBL_WM="${MAUVE}󰖲 WM${NC}"
LBL_CPU="${RED}󰻠 CPU${NC}"
LBL_GPU="${RED}󰍹 GPU${NC}"
LBL_SHELL="${TEAL} Shell${NC}"
LBL_PACKAGES="${GREEN}󰏖 Packages${NC}"
LBL_MEMORY="${GREEN}󰍛 Memory${NC}"
# -----------------------------------

# Image path
IMAGE_PATH="/home/azunya/Pictures/AzuNyan-azusa-nakano.png" # image path

# Pemeriksaan dependensi
if [ ! -f "$IMAGE_PATH" ]; then echo "Error: Gambar tidak ditemukan." >&2; exit 1; fi
if ! command -v chafa >/dev/null; then echo "Error: chafa tidak ditemukan." >&2; exit 1; fi

# --- Fungsi Pengumpul Informasi ---
get_info() {
    user_info="$USER@$(hostname)"
    if [ -f /etc/os-release ]; then . /etc/os-release; distro_info="$PRETTY_NAME"; else distro_info=$(uname -s); fi
    kernel_info=$(uname -r)
    uptime_info=$(uptime -p | sed 's/up //')
    
    de_info="${XDG_CURRENT_DESKTOP:-}"
    if [ -z "$de_info" ]; then
        if pgrep -x "gnome-shell" >/dev/null; then de_info="GNOME"; 
        elif pgrep -x "plasmashell" >/dev/null; then de_info="KDE Plasma";
        elif pgrep -x "xfce4-session" >/dev/null; then de_info="XFCE";
        else de_info="Unknown"; fi
    fi
    de_info="${de_info##*:}"
    de_info="${de_info^}"

    declare -A wm_processes=(
        [kwin_x11]="KWin" [kwin_wayland]="KWin" [mutter]="Mutter"
        [xfwm4]="Xfwm4" [i3]="i3" [bspwm]="bspwm" [sway]="Sway"
        [Hyprland]="Hyprland" [openbox]="Openbox" [fluxbox]="Fluxbox"
        [qtile]="Qtile" [marco]="Marco" [dwm]="dwm"
    )
    wm_info="Unknown"
    for process in "${!wm_processes[@]}"; do
        if pgrep -x "$process" &>/dev/null; then
            wm_info="${wm_processes[$process]}"
            break
        fi
    done
    if [[ "$de_info" == "$wm_info" ]]; then de_info="$wm_info"; fi

    cpu_info=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d: -f2 | sed 's/^[ \t]*//')
    if command -v lspci >/dev/null; then
        gpu_info=$(lspci | grep -Ei 'VGA|3D' | head -n1 | cut -d: -f3 | sed -e 's/ (rev ..)//' -e 's/^[ \t]*//' -e 's/\[.*\]//')
    else
        gpu_info="lspci not found"
    fi
    shell_info=$(basename "$SHELL")
    if command -v apt >/dev/null; then
        packages_info="$(dpkg-query -f '.\n' -W | wc -l) (apt)"
    elif command -v pacman >/dev/null; then
        packages_info="$(pacman -Q | wc -l) (pacman)"
    else
        packages_info="Unknown"
    fi
    memory_display=$(free -m | awk 'NR==2{printf "%.1f / %.1f GB (%d%%)", $3/1024, $2/1024, $3*100/$2}')
}

# --- Fungsi Tampilan Utama ---
display_info() {
    clear
    get_info

    local COLS=$(tput cols)
    local IMG_WIDTH=$((COLS * 45 / 100)); if [ $IMG_WIDTH -gt 55 ]; then IMG_WIDTH=55; fi
    local IMG_HEIGHT=22

    local temp_img=$(mktemp)
    local temp_info=$(mktemp)
    trap 'rm -f "$temp_img" "$temp_info"' EXIT

    chafa "$IMAGE_PATH" --size="${IMG_WIDTH}x${IMG_HEIGHT}" --format=ansi > "$temp_img"

    {
        local labels=("$LBL_DISTRO" "$LBL_KERNEL" "$LBL_UPTIME" "$LBL_DE" "$LBL_WM" "$LBL_CPU" "$LBL_GPU" "$LBL_SHELL" "$LBL_PACKAGES" "$LBL_MEMORY")
        local values=("$distro_info" "$kernel_info" "$uptime_info" "$de_info" "$wm_info" "$cpu_info" "$gpu_info" "$shell_info" "$packages_info" "$memory_display")

        local max_label_len=0
        for label in "${labels[@]}"; do
            local len
            len=$(echo -ne "$label" | sed 's/\x1b\[[0-9;?]*[mK]//g' | wc -m)
            if (( len > max_label_len )); then
                max_label_len=$len
            fi
        done

        local info_lines=()
        for i in "${!labels[@]}"; do
            local line
            line=$(printf "%-*b : ${TEXT}%s${NC}" "$max_label_len" "${labels[i]}" "${values[i]}")
            info_lines+=("$line")
        done

        local max_total_len=0
        for line in "${info_lines[@]}"; do
            local len
            len=$(echo -ne "$line" | sed 's/\x1b\[[0-9;?]*[mK]//g' | wc -m)
            if (( len > max_total_len )); then
                max_total_len=$len
            fi
        done

        local title=" ${BLUE}󰣋 ${user_info}${NC} "
        local title_visible
        title_visible=$(echo -e "$title" | sed 's/\x1b\[[0-9;?]*[mK]//g')
        local title_len=${#title_visible}
        local bar_width=$((max_total_len + 2))
        local total_bar_len=$((bar_width - title_len))
        local left_bar_len=$((total_bar_len / 2))
        local right_bar_len=$((total_bar_len - left_bar_len))
        
        local top_border="╭$(printf '─%.0s' $(seq 1 $left_bar_len))${title}$(printf '─%.0s' $(seq 1 $right_bar_len))╮"
        local bottom_border="╰$(printf '─%.0s' $(seq 1 $bar_width))╯"

        echo -e "\n  ${LAVENDER}${top_border}${NC}"
        for line in "${info_lines[@]}"; do
            local visible_line
            visible_line=$(echo -e "$line" | sed 's/\x1b\[[0-9;?]*[mK]//g')
            local current_len=${#visible_line}
            local padding=$((max_total_len - current_len))
            printf "  ${LAVENDER}│${NC} %s%*s ${LAVENDER}│${NC}\n" "$line" "$padding" ""
        done
        echo -e "  ${LAVENDER}${bottom_border}${NC}"

    } > "$temp_info"

    paste -d' ' "$temp_img" "$temp_info"
}

# Jalankan skrip
display_info
