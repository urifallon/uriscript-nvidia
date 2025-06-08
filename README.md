# 🚀 NVIDIA + CUDA Install Script (Ubuntu)

This is a shell script to **automatically install the latest or a specific version of the NVIDIA GPU driver and CUDA Toolkit** on **Ubuntu-based systems**.

---

## 📌 Description

This script offers a simple interactive menu with two installation options:

- 🧠 **Auto Install**: Automatically installs the latest recommended NVIDIA driver and latest compatible CUDA version.
- 🎯 **Manual Install**: Allows you to specify a desired CUDA version (e.g., 12.4, 11.8) to be installed.

The script performs the following tasks:

- Removes any previously installed NVIDIA drivers (optional and interactive).
- Updates system packages and installs required dependencies.
- Installs the appropriate NVIDIA driver via `ubuntu-drivers autoinstall`.
- Installs CUDA Toolkit using `.run` installers or APT (if supported).
- Sets up environment variables (`PATH`, `LD_LIBRARY_PATH`) for CUDA.
- Verifies installation with `nvidia-smi` and `nvcc`.

---

## ⚙️ Requirements

- OS: Ubuntu 20.04+, 22.04+ recommended  
- `sudo` privileges required  
- Internet connection (for downloading packages)

---

## 🛠️ Usage

1. Download the script:
   ```bash
   mkdir -p nvidia-installer && cd nvidia-installer
   curl -O https://yourdomain.com/nvidia_cuda_installer.sh
   ```

2. Make it executable and run:
   ```bash
   chmod +x nvidia_cuda_installer.sh
   sudo ./nvidia_cuda_installer.sh
   ```

## 🇻🇳 Vietnamese Version

A Vietnamese version of this script is available [here](https://yourdomain.com/nvidia_cuda_installer_vn.sh), or you can run:

```bash
curl -O https://yourdomain.com/nvidia_cuda_installer_vn.sh
chmod +x nvidia_cuda_installer_vn.sh
sudo ./nvidia_cuda_installer_vn.sh
```
---

## 🧪 After Installation

You can check your installation using the following commands:

```bash
nvidia-smi          # Shows GPU and driver info
nvcc --version      # Displays the installed CUDA Toolkit version
```

If `nvcc` is not found, you may need to re-source your profile:

```bash
source ~/.bashrc
```

---

## 📥 Script Output Sample

```bash
========== NVIDIA & CUDA INSTALL MENU ==========
1. Auto install the latest NVIDIA driver and CUDA
2. Install specific version of NVIDIA driver and CUDA
0. Exit
Enter your choice [0-2]: 
```

---

## 🌐 Notes

- When installing a specific CUDA version, ensure it is available on the [NVIDIA CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive).
- After installation, it is recommended to **reboot** your system to apply driver changes.
- The script is modular and easy to modify to fit your infrastructure.


---

## 🧰 Troubleshooting

- If `nvidia-smi` fails, try rebooting or checking driver compatibility.
- Ensure that secure boot is disabled if the driver does not load properly.
- Refer to the [CUDA Compatibility Guide](https://docs.nvidia.com/deploy/cuda-compatibility/) for more information.

---

