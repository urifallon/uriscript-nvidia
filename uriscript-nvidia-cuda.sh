#!/bin/bash

# ===== CHECK FOR ROOT PERMISSION =====
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root (use sudo)."
  exit 1
fi

# ===== INSTALLATION MENU =====
echo "========== NVIDIA & CUDA INSTALL MENU =========="
echo "1. Auto install the latest NVIDIA driver and CUDA"
echo "2. Install specific version of NVIDIA driver and CUDA"
echo "0. Exit"
read -p "Enter your choice [0-2]: " choice

# ===== REMOVE OLD NVIDIA DRIVERS =====
remove_old_nvidia() {
  echo "🧹 Removing old NVIDIA drivers (if any)..."
  apt remove --purge '^nvidia-.*' -y
  apt autoremove -y
}

# ===== SETUP CUDA ENVIRONMENT VARIABLES =====
setup_env() {
  echo "🛠 Setting environment variables for CUDA..."
  if ! grep -q "/usr/local/cuda/bin" ~/.bashrc; then
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
  fi
  source ~/.bashrc
}

# ===== OPTION 1: AUTO INSTALL =====
auto_install() {
  echo "🔄 Updating system..."
  apt update && apt upgrade -y

  remove_old_nvidia

  echo "📥 Installing latest NVIDIA driver..."
  ubuntu-drivers autoinstall

  echo "📦 Installing default CUDA toolkit..."
  apt install -y nvidia-cuda-toolkit

  setup_env

  echo "✅ Installation complete!"
  nvidia-smi
  nvcc --version || echo "⚠️ CUDA not available yet. Please reboot."
}

# ===== OPTION 2: INSTALL SPECIFIC VERSION =====
install_with_version() {
  read -p "Enter the CUDA version you want to install (e.g. 12.5): " cuda_ver

  echo "🔄 Updating system..."
  apt update && apt upgrade -y

  remove_old_nvidia

  echo "📥 Installing latest NVIDIA driver..."
  ubuntu-drivers autoinstall

  echo "🌐 Downloading CUDA $cuda_ver..."
  UBUNTU_VER=$(lsb_release -rs | sed 's/\.//')
  CUDA_PKG="cuda-repo-ubuntu${UBUNTU_VER}-${cuda_ver}-local_${cuda_ver}.*_amd64.deb"

  rm -f /tmp/cuda.deb
  wget "https://developer.download.nvidia.com/compute/cuda/${cuda_ver}/local_installers/${CUDA_PKG}" -O /tmp/cuda.deb

  echo "📦 Installing CUDA $cuda_ver..."
  dpkg -i /tmp/cuda.deb
  cp /var/cuda-repo*/cuda-*-keyring.gpg /usr/share/keyrings/
  apt update
  apt install -y cuda

  setup_env

  echo "✅ Installation complete!"
  nvidia-smi
  nvcc --version || echo "⚠️ CUDA not available yet. Please reboot."
}

# ===== HANDLE USER CHOICE =====
case "$choice" in
  1)
    auto_install
    ;;
  2)
    install_with_version
    ;;
  0)
    echo "👋 Exiting script."
    exit 0
    ;;
  *)
    echo "❌ Invalid choice!"
    ;;
esac
