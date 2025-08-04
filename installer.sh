#!/bin/bash

# --- INSTALLER CONFIGURATION ---
# The source script file to be installed
SOURCE_SCRIPT="simfetch"
# The final command name after installation
CMD_NAME="simfetch"
# The installation directory (standard for local user binaries)
INSTALL_DIR="$HOME/.local/bin"

# --- HELPER FUNCTIONS FOR LOGGING ---
info() {
    echo -e "[\033[0;94mINFO\033[0m] $1"
}
success() {
    echo -e "[\033[0;92mSUCCESS\033[0m] $1"
}
error() {
    echo -e "[\033[0;91mERROR\033[0m] $1" >&2
}
warning() {
    echo -e "[\033[0;93mWARNING\033[0m] $1"
}

# --- INSTALLATION PROCESS ---

# 1. Check if the source script file exists in the current directory
info "Searching for file '$SOURCE_SCRIPT'..."
if [ ! -f "$SOURCE_SCRIPT" ]; then
    error "File '$SOURCE_SCRIPT' not found."
    error "Make sure 'installer.sh' and '$SOURCE_SCRIPT' are in the same folder."
    exit 1
fi
success "File '$SOURCE_SCRIPT' found."

# 2. Set executable permission
info "Setting executable permission on '$SOURCE_SCRIPT'..."
chmod +x "$SOURCE_SCRIPT"

# 3. Ensure the installation directory exists
info "Ensuring installation directory '$INSTALL_DIR' exists..."
mkdir -p "$INSTALL_DIR"

# 4. Move and rename the script to the installation directory
info "Installing '$SOURCE_SCRIPT' as '$CMD_NAME' to '$INSTALL_DIR'..."
mv "$SOURCE_SCRIPT" "$INSTALL_DIR/$CMD_NAME"

# --- FINAL MESSAGE ---
echo ""
success "Installation of '$CMD_NAME' complete!"
echo ""
info "You can now run the script from anywhere by typing:"
info "  $CMD_NAME"
echo ""
warning "If the command is not found, please close and reopen your terminal,"
warning "or add the following line to your '~/.bashrc' or '~/.zshrc' file:"
warning "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""