#!/bin/bash

# ===== KIỂM TRA QUYỀN ROOT =====
if [ "$EUID" -ne 0 ]; then
  echo "❌ Vui lòng chạy script với quyền root (sudo)."
  exit 1
fi

# ===== MENU LỰA CHỌN =====
echo "========== MENU CÀI ĐẶT =========="
echo "1. Tự động cài driver NVIDIA và CUDA mới nhất"
echo "2. Cài driver NVIDIA và CUDA với phiên bản tùy chọn"
echo "0. Thoát"
read -p "Nhập lựa chọn của bạn [0-2]: " choice

# ===== GỠ DRIVER CŨ (CHUNG) =====
remove_old_nvidia() {
  echo "🧹 Gỡ driver NVIDIA cũ (nếu có)..."
  apt remove --purge '^nvidia-.*' -y
  apt autoremove -y
}

# ===== THIẾT LẬP BIẾN MÔI TRƯỜNG =====
setup_env() {
  echo "🛠 Thiết lập biến môi trường cho CUDA..."
  if ! grep -q "/usr/local/cuda/bin" ~/.bashrc; then
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
  fi
  source ~/.bashrc
}

# ===== OPTION 1: AUTO INSTALL =====
auto_install() {
  echo "🔄 Cập nhật hệ thống..."
  apt update && apt upgrade -y

  remove_old_nvidia

  echo "📥 Cài đặt NVIDIA driver mới nhất..."
  ubuntu-drivers autoinstall

  echo "📦 Cài đặt CUDA (phiên bản đi kèm driver)..."
  apt install -y nvidia-cuda-toolkit

  setup_env

  echo "✅ Hoàn tất!"
  nvidia-smi
  nvcc --version || echo "⚠️ CUDA chưa khả dụng, cần khởi động lại."
}

# ===== OPTION 2: INSTALL WITH VERSION =====
install_with_version() {
  read -p "Nhập phiên bản CUDA muốn cài (VD: 12.5): " cuda_ver

  echo "🔄 Cập nhật hệ thống..."
  apt update && apt upgrade -y

  remove_old_nvidia

  echo "📥 Cài đặt NVIDIA driver mới nhất..."
  ubuntu-drivers autoinstall

  echo "📦 Đang tải CUDA $cuda_ver..."
  UBUNTU_VER=$(lsb_release -rs | sed 's/\.//')
  CUDA_PKG="cuda-repo-ubuntu${UBUNTU_VER}-${cuda_ver}-local_${cuda_ver}.*_amd64.deb"

  # Gỡ bản cũ
  rm -f /tmp/cuda.deb

  # Tải CUDA
  wget "https://developer.download.nvidia.com/compute/cuda/${cuda_ver}/local_installers/${CUDA_PKG}" -O /tmp/cuda.deb

  # Cài đặt
  dpkg -i /tmp/cuda.deb
  cp /var/cuda-repo*/cuda-*-keyring.gpg /usr/share/keyrings/
  apt update
  apt install -y cuda

  setup_env

  echo "✅ Hoàn tất!"
  nvidia-smi
  nvcc --version || echo "⚠️ CUDA chưa khả dụng, cần khởi động lại."
}

# ===== XỬ LÝ LỰA CHỌN =====
case "$choice" in
  1)
    auto_install
    ;;
  2)
    install_with_version
    ;;
  0)
    echo "👋 Thoát script."
    exit 0
    ;;
  *)
    echo "❌ Lựa chọn không hợp lệ!"
    ;;
esac
