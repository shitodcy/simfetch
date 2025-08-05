#!/bin/bash

SOURCE_SCRIPT="simfetch"
CMD_NAME="simfetch"
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/simfetch"
CONFIG_FILE="$CONFIG_DIR/simfetch.conf"

GREEN='\033[0;32m'
BLUE='\033[0;94m'
YELLOW='\033[0;93m'
RED='\033[0;91m'
NC='\033[0m'

TICK="[${GREEN}✔${NC}]"
CROSS="[${RED}✖${NC}]"
WARN="[${YELLOW}❗${NC}]"

echo -e "${BLUE}🚀 Starting full customization setup for simfetch...${NC}"

if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo -e " ${CROSS} Source script '${SOURCE_SCRIPT}' not found. Aborting."
    exit 1
fi
echo -e " ${TICK} Found source script '${SOURCE_SCRIPT}'."

mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"
echo -e " ${TICK} Directories ensured."

cp "$SOURCE_SCRIPT" "$CONFIG_FILE"
echo -e " ${TICK} Copied full script to '${CONFIG_FILE}' for editing."

cat << EOF > "$INSTALL_DIR/$CMD_NAME"
#!/bin/bash
# This is a launcher script.
# To customize simfetch, edit the file below:
# ~/.config/simfetch/simfetch.conf

# Execute the main script from the config file
bash "\$HOME/.config/simfetch/simfetch.conf"
EOF

chmod +x "$INSTALL_DIR/$CMD_NAME"
echo -e " ${TICK} Launcher created at '${INSTALL_DIR}/${CMD_NAME}'."


echo ""
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo ""
echo -e "   The entire simfetch code is now yours to edit at:"
echo -e "   ${YELLOW}${CONFIG_FILE}${NC}"
echo ""
echo -e "   Run the command anytime with:"
echo -e "   ${BLUE}simfetch${NC}"
echo ""
echo -e " ${WARN} If the command is not found, please restart your terminal."
echo ""
