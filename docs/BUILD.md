# Build Guide - Cross-Platform Compilation

## Prerequisites

### Common Requirements
- **CMake 3.20+**: Build system generator
- **C++20 compatible compiler**: 
  - GCC 10+ / Clang 12+ (Linux/macOS)
  - MSVC 2019+ / MinGW-w64 10+ (Windows)
- **libcurl development library**: HTTP/SMTP client library
- **OpenSSL**: SSL/TLS support (usually bundled with libcurl)

## Linux Build Instructions

### Ubuntu/Debian
```bash
# Install dependencies
sudo apt update
sudo apt install build-essential cmake libcurl4-openssl-dev

# Build the project
cd smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(nproc)

# Run the executable
./send_mail
```

### CentOS/RHEL/Fedora
```bash
# Install dependencies
sudo dnf install cmake gcc-c++ libcurl-devel openssl-devel

# Build the project
cd smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(nproc)

# Run the executable
./send_mail
```

### Arch Linux
```bash
# Install dependencies
sudo pacman -S cmake gcc libcurl openssl

# Build the project
cd smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(nproc)

# Run the executable
./send_mail
```

### Build with Conan (Advanced)
```bash
# Install Conan
pip install conan

# Configure dependencies
cd smtp_client/examples/cpp
conan install . --build=missing

# Build with CMake
cmake --preset conan-release
cmake --build --preset conan-release

# Run the executable
./build/send_mail
```

## Windows Build Instructions

### Method 1: Visual Studio (Recommended)

#### Prerequisites
1. **Visual Studio 2019+** with C++ development tools
2. **vcpkg** (Microsoft package manager)
3. **Git**

#### Setup
```cmd
# Clone and setup vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install

# Install dependencies
.\vcpkg install curl[openssl]:x64-windows
```

#### Build
```cmd
# Open Developer Command Prompt for VS
# Navigate to project directory
cd path\to\smtp_client\examples\cpp

# Configure with vcpkg toolchain
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake -A x64

# Build with Visual Studio
cmake --build . --config Release

# Run the executable
.\Release\send_mail.exe
```

### Method 2: MinGW-w64

#### Prerequisites
1. **MSYS2**: https://www.msys2.org/
2. **MinGW-w64 toolchain**

#### Setup
```bash
# In MSYS2 MINGW64 terminal
pacman -Syu
pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc mingw-w64-x86_64-curl mingw-w64-x86_64-openssl

# Build the project
cd /c/path/to/smtp_client/examples/cpp
mkdir build && cd build
cmake .. -G "MinGW Makefiles"
mingw32-make

# Run the executable
./send_mail.exe
```

### Method 3: WSL (Windows Subsystem for Linux)

#### Setup
```powershell
# Install WSL with Ubuntu
wsl --install -d Ubuntu

# In WSL terminal
sudo apt update
sudo apt install build-essential cmake libcurl4-openssl-dev

# Build as Linux
cd /mnt/c/path/to/smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(nproc)

# Run the executable
./send_mail
```

## macOS Build Instructions

### Homebrew (Recommended)
```bash
# Install dependencies
brew install cmake libcurl

# Build the project
cd smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(sysctl -n hw.ncpu)

# Run the executable
./send_mail
```

### MacPorts
```bash
# Install dependencies
sudo port install cmake curl

# Build the project
cd smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(sysctl -n hw.ncpu)

# Run the executable
./send_mail
```

## Build Configuration Options

### CMake Options
```bash
# Debug build
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Release build (default)
cmake -DCMAKE_BUILD_TYPE=Release ..

# Custom install prefix
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..

# Enable verbose output
make VERBOSE=1
```

### Cross-Compilation
```bash
# Windows cross-compilation from Linux
cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain-windows.cmake

# ARM64 cross-compilation
cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm64.cmake
```

## Troubleshooting

### Common Issues

#### libcurl not found
```bash
# Ubuntu/Debian
sudo apt install libcurl4-openssl-dev

# CentOS/RHEL  
sudo yum install libcurl-devel

# Windows (vcpkg)
vcpkg install curl[openssl]:x64-windows
```

#### OpenSSL not found
```bash
# Usually comes with libcurl, but if needed:
# Ubuntu/Debian
sudo apt install libssl-dev

# CentOS/RHEL
sudo yum install openssl-devel
```

#### CMake version too old
```bash
# Ubuntu 20.04: Update CMake
wget https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1-linux-x86_64.sh
sudo sh cmake-3.25.1-linux-x86_64.sh --skip-license --prefix=/usr/local
```

#### Windows PATH issues
```cmd
# Add vcpkg to PATH
set PATH=%PATH%;C:\vcpkg\installed\x64-windows\bin

# Or set environment variable permanently
setx PATH "%PATH%;C:\vcpkg\installed\x64-windows\bin"
```

#### SSL Certificate Issues
```bash
# On Linux, update CA certificates
sudo update-ca-certificates

# On Windows, ensure curl can find CA bundle
set CURL_CA_BUNDLE=C:\path\to\cacert.pem
```

## Automated Build Scripts

### Linux/macOS (build.sh)
```bash
#!/bin/bash
set -e

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y build-essential cmake libcurl4-openssl-dev
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y cmake gcc-c++ libcurl-devel openssl-devel
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --needed cmake gcc libcurl openssl
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &> /dev/null; then
        brew install cmake libcurl
    fi
fi

# Build
cd "$(dirname "$0")"
mkdir -p build
cd build
cmake ..
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu)

echo "Build complete! Run ./build/send_mail"
```

### Windows (build.bat)
```batch
@echo off
if not exist "vcpkg" (
    git clone https://github.com/Microsoft/vcpkg.git
    cd vcpkg
    call bootstrap-vcpkg.bat
    call vcpkg integrate install
    call vcpkg install curl[openssl]:x64-windows
    cd ..
)

if not exist "build" mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake -A x64
cmake --build . --config Release

echo Build complete! Run build\Release\send_mail.exe
```

## Performance Optimization

### Compiler Optimizations
```bash
# Maximum optimization
cmake -DCMAKE_BUILD_TYPE=Release ..
make CXXFLAGS="-O3 -march=native"

# Link-time optimization
cmake -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=TRUE ..
```

### Binary Size Optimization
```bash
# Strip symbols
strip send_mail

# Static linking (smaller deployment, larger binary)
cmake -DCURL_STATICLIB=ON ..
```