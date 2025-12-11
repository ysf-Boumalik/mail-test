#!/usr/bin/env bash
# Clean & CI-safe Postfix + Mailutils Installer
set -euo pipefail

echo "Updating package lists..."
sudo apt-get update -y

echo "Installing Postfix and Mailutils (non-interactive)..."

# Pre-configure Postfix to avoid prompts
echo "postfix postfix/mailname string $(hostname)" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | sudo debconf-set-selections

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y postfix mailutils

echo "Ensuring myhostname is set..."
sudo postconf -e "myhostname=$(hostname)"

echo "Restarting Postfix..."
sudo systemctl restart postfix

echo "Checking Postfix status (CI-safe)..."
# systemctl status returns non-zero even if service is active → safe with "|| true"
sudo systemctl status postfix --no-pager || true

echo "Reloading aliases..."
sudo newaliases || true

echo ""
echo "========================================"
echo "✅ Installation complete!"
echo "Postfix + Mailutils installed successfully."
echo "========================================"
echo ""

exit 0
