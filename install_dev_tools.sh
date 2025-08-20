#!/usr/bin/env bash
set -euo pipefail

TAG="install_dev_tools"

command -v dnf >/dev/null 2>&1 || { echo "This script targets Fedora (dnf)."; logger -t "$TAG" "No dnf found"; exit 1; }
sudo -v

echo "==> Docker Engine & Compose"

if command -v docker >/dev/null 2>&1; then
  echo "Docker already installed: $(docker --version)"
else
  sudo dnf -y install moby-engine
  sudo systemctl enable --now docker
  echo "Docker installed: $(docker --version)"
fi

if ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER" || true
  echo "Added '$USER' to 'docker' group."
fi

if docker compose version >/dev/null 2>&1; then
  echo "Compose v2 available: $(docker compose version | head -n1)"
else
  echo "Installing Compose v2 plugin (if available)..."
  if sudo dnf -y install docker-compose-plugin; then
    echo "Compose v2 plugin installed: $(docker compose version | head -n1)"
  else
    echo "Plugin not found in repos — installing docker-compose package (v2)..."
    sudo dnf -y install docker-compose
    echo "docker-compose installed: $(docker-compose version)"
  fi
fi

echo "==> Python3 & pip"

if command -v python3 >/dev/null 2>&1; then
  PY_VER="$(python3 -V 2>&1 | awk '{print $2}')"
  echo "python3 present: $PY_VER"
else
  sudo dnf -y install python3
  echo "Installed python3: $(python3 -V 2>&1 | awk '{print $2}')"
fi

# pip
if python3 -m pip --version >/dev/null 2>&1; then
  echo "pip present"
else
  sudo dnf -y install python3-pip
  echo "Installed python3-pip"
fi

echo "==> Django (user install)"

if python3 -m django --version >/dev/null 2>&1; then
  echo "Django already installed: $(python3 -m django --version)"
else
  python3 -m pip install --user --upgrade pip >/dev/null
  python3 -m pip install --user Django
  echo "Installed Django: $(python3 -m django --version)"
fi

echo "All done."
