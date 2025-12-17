#!/usr/bin/bash

set -eoux pipefail

echo "::group:: Install Ublue OS Packages"

dnf5 -y just
copr_install_isolated "ublue-os/packages" uupd ublue-os-just ublue-os-udev-rules ublue-os-update-services ublue-os-signing ublue-os-luks
systemctl enable uupd.timer

echo "::endgroup::"

echo "::group:: Install Homebrew"

# Install dependencies for Homebrew
dnf5 -y install procps-ng curl file git

# Create a non-root user for Homebrew
useradd --system --create-home --shell /bin/bash linuxbrew

# Run the Homebrew installer as the 'linuxbrew' user
/bin/su -l linuxbrew <<'EOF'
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
EOF

# Add Homebrew to the system's path for all users
# shellcheck disable=SC2016
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' > /etc/profile.d/brew.sh
ln -s /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew

echo "::endgroup::"
