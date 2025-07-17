#!/bin/bash

# ==============================================================================
# Suricata Installation and Custom Configuration Script (GitHub Version)
# ==============================================================================
#
# Description:
# This script automates the installation of Suricata on a Debian-based
# system (like Ubuntu) and configures it to use custom configuration
# and rule files fetched directly from a GitHub repository.
#
# Author: Muhammad Ryan Fachri Addar (adapted for general use)
#
# Instructions:
# 1. Make the script executable:
#    chmod +x install_suricata.sh
#
# 2. Run the script with root privileges:
#    sudo ./install_suricata.sh
#
# ==============================================================================

# --- Script Functions ---

# Function to print messages in a standardized way
print_message() {
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

# --- Main Script ---

# 1. Check for Root Privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use 'sudo'." >&2
  exit 1
fi

# --- GitHub Raw Content URLs ---
YAML_URL="https://raw.githubusercontent.com/Hassanfach/Suricata-IDS-With-SIEM-Integration/main/subsistem-analisis-deteksi/suricata.yaml"
RULES_URL="https://raw.githubusercontent.com/Hassanfach/Suricata-IDS-With-SIEM-Integration/main/subsistem-analisis-deteksi/custom.rules"


print_message "Starting Suricata Installation and Configuration"

# 2. Install Dependencies and Suricata
print_message "Step 1: Installing Dependencies and Suricata..."
apt-get update
# Install wget to download files, and other dependencies
apt-get install -y wget software-properties-common
add-apt-repository -y ppa:oisf/suricata-stable
apt-get update
apt-get install -y suricata

# Check if Suricata was installed successfully
if ! [ -x "$(command -v suricata)" ]; then
  echo "Error: Suricata installation failed." >&2
  exit 1
fi
echo "Suricata installed successfully."


# 3. Download Custom Configuration from GitHub
print_message "Step 2: Downloading custom configuration from GitHub..."

wget -O suricata.yaml.tmp "$YAML_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download suricata.yaml from GitHub. Please check the URL." >&2
    exit 1
fi
echo "Custom suricata.yaml downloaded."

wget -O custom.rules.tmp "$RULES_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download custom.rules from GitHub. Please check the URL." >&2
    exit 1
fi
echo "Custom custom.rules downloaded."


# 4. Define System Paths
SURICATA_CONFIG_DIR="/etc/suricata/"
SURICATA_RULES_DIR="/etc/suricata/rules/"


# 5. Backup and Replace Configuration Files
print_message "Step 3: Backing up and replacing configuration files..."

# Backup the original suricata.yaml file
if [ -f "${SURICATA_CONFIG_DIR}suricata.yaml" ]; then
    mv "${SURICATA_CONFIG_DIR}suricata.yaml" "${SURICATA_CONFIG_DIR}suricata.yaml.bak"
    echo "Original suricata.yaml backed up to suricata.yaml.bak"
fi

# Copy your custom suricata.yaml
mv suricata.yaml.tmp "${SURICATA_CONFIG_DIR}suricata.yaml"
echo "Custom suricata.yaml has been copied."

# Copy your custom rules file
mv custom.rules.tmp "${SURICATA_RULES_DIR}custom.rules"
echo "Custom rules file has been copied to the rules directory."


# 6. Update Suricata to Load Custom Rules
# We need to ensure that the main suricata.yaml file knows to load our custom.rules.
# This part checks if 'custom.rules' is already listed in the config. If not, it adds it.
print_message "Step 4: Updating rule-files configuration..."

if ! grep -q "custom.rules" "${SURICATA_CONFIG_DIR}suricata.yaml"; then
    echo "Adding custom.rules to the rule-files section in suricata.yaml..."
    # This sed command finds the 'rule-files:' section and appends our custom rule file.
    sed -i "/rule-files:/a \ \ - custom.rules" "${SURICATA_CONFIG_DIR}suricata.yaml"
else
    echo "custom.rules is already listed in suricata.yaml. No changes needed."
fi

# 7. Final Instructions
print_message "Installation and Configuration Complete!"
echo "Suricata is now installed and configured with your custom files from GitHub."
echo ""
echo "To test the configuration, run:"
echo "sudo suricata-test -c ${SURICATA_CONFIG_DIR}suricata.yaml -v"
echo ""
echo "To run Suricata on an interface (e.g., eth0), use:"
echo "sudo suricata -c ${SURICATA_CONFIG_DIR}suricata.yaml -i eth0"
echo ""

exit 0
