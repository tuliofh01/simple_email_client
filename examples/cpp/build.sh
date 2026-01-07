#!/bin/bash
set -e

BUILD_SCRIPT_VERSION="1.0.0"

echo "SMTP Client Build Script v$BUILD_SCRIPT_VERSION"
echo "=========================================="

# Function to show usage
show_help() {
    echo 'Usage: ./build.sh [action] [build_type]'
    echo ''
    echo 'Actions:'
    echo '  deps,dependencies  Install dependencies only'
    echo '  build             Build project (default)'
    echo '  test              Run tests'
    echo '  install           Install project to system'
    echo '  package           Create distribution package'
    echo '  clean             Clean build directories'
    echo '  all               Install deps, build and test'
    echo '  help              Show this help message'
    echo ''
    echo 'Build Types:'
    echo '  Release           Optimized build (default)'
    echo '  Debug             Debug build with symbols'
    echo ''
    echo 'Examples:'
    echo '  ./build.sh                    # Build release version'
    echo '  ./build.sh build Debug        # Build debug version'
    echo '  ./build.sh deps               # Install dependencies only'
    echo '  ./build.sh all                # Install deps, build and test'
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            echo "debian"
        elif [ -f /etc/redhat-release ]; then
            echo "redhat"
        elif [ -f /etc/arch-release ]; then
            echo "arch"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to install dependencies
install_dependencies() {
    local os=$(detect_os)
    echo "Detected OS: $os"
    
    case $os in
        debian)
            echo 'Installing dependencies for Debian/Ubuntu...'
            if command -v apt-get &> /dev/null; then
                sudo apt-get update
                sudo apt-get install -y build-essential cmake libcurl4-openssl-dev
            else
                echo 'apt-get not found. Please install dependencies manually.'
                exit 1
            fi
            ;;
        redhat)
            echo 'Installing dependencies for RedHat/CentOS/Fedora...'
            if command -v dnf &> /dev/null; then
                sudo dnf install -y cmake gcc-c++ libcurl-devel openssl-devel
            elif command -v yum &> /dev/null; then
                sudo yum install -y cmake gcc-c++ libcurl-devel openssl-devel
            else
                echo 'Neither dnf nor yum found. Please install dependencies manually.'
                exit 1
            fi
            ;;
        arch)
            echo 'Installing dependencies for Arch Linux...'
            if command -v pacman &> /dev/null; then
                sudo pacman -S --needed cmake gcc libcurl openssl
            else
                echo 'pacman not found. Please install dependencies manually.'
                exit 1
            fi
            ;;
        macos)
            echo 'Installing dependencies for macOS...'
            if command -v brew &> /dev/null; then
                brew install cmake libcurl
            elif command -v port &> /dev/null; then
                sudo port install cmake curl
            else
                echo 'Neither Homebrew nor MacPorts found. Please install dependencies manually.'
                echo 'Install Homebrew: https://brew.sh/'
                exit 1
            fi
            ;;
        *)
            echo 'Generic system detected. Please install dependencies manually:'
            echo '  - cmake (version 3.20 or higher)'
            echo '  - C++20 compatible compiler'
            echo '  - libcurl development library'
            echo '  - OpenSSL development library'
            exit 1
            ;;
    esac
}

# Function to build project
build_project() {
    local build_type=${1:-Release}
    local build_dir="build"
    
    if [ "$build_type" = "Debug" ]; then
        build_dir="build-debug"
    fi
    
    echo "Building project: $build_type"
    
    # Clean previous build
    if [ -d "$build_dir" ]; then
        echo "Cleaning previous build..."
        rm -rf "$build_dir"
    fi
    
    # Use CMake presets if available
    if [ "$build_type" = "Release" ]; then
        if cmake --preset default 2>/dev/null; then
            cmake --build --preset default
            return
        fi
    elif [ "$build_type" = "Debug" ]; then
        if cmake --preset debug 2>/dev/null; then
            cmake --build --preset debug
            return
        fi
    fi
    
    # Fallback to manual configuration
    mkdir -p "$build_dir"
    cd "$build_dir"
    cmake .. -DCMAKE_BUILD_TYPE="$build_type"
    
    # Determine number of parallel jobs
    if command -v nproc >/dev/null 2>&1; then
        make -j$(nproc)
    elif command -v sysctl >/dev/null 2>&1; then
        make -j$(sysctl -n hw.ncpu)
    else
        make
    fi
    cd ..
}

# Function to run tests
run_tests() {
    echo 'Running tests...'
    if [ -d "build" ]; then
        cd build
        ctest --output-on-failure
        cd ..
    elif [ -d "build-debug" ]; then
        cd build-debug
        ctest --output-on-failure
        cd ..
    else
        echo 'No build directory found. Build project first.'
        exit 1
    fi
}

# Function to install project
install_project() {
    echo 'Installing project...'
    if [ -d "build" ]; then
        cd build
        sudo make install
        cd ..
        echo 'Project installed to /usr/local/bin/send_mail'
    elif [ -d "build-debug" ]; then
        cd build-debug
        sudo make install
        cd ..
        echo 'Project installed to /usr/local/bin/send_mail'
    else
        echo 'No build directory found. Build project first.'
        exit 1
    fi
}

# Function to clean build
clean_build() {
    echo 'Cleaning build directories...'
    rm -rf build build-debug
    echo 'Clean completed.'
}

# Function to create package
create_package() {
    echo 'Creating package...'
    if [ -d "build" ]; then
        cd build
        cpack
        cd ..
        echo 'Package created in build directory'
    else
        echo 'No build directory found. Build project first.'
        exit 1
    fi
}

# Main execution
main() {
    local action=${1:-build}
    local build_type=${2:-Release}
    
    echo "Action: $action"
    echo "Build Type: $build_type"
    echo ''
    
    case $action in
        deps|dependencies)
            install_dependencies
            ;;
        build)
            install_dependencies
            build_project "$build_type"
            echo ''
            echo 'Build completed successfully!'
            echo 'Executable location: build/send_mail'
            ;;
        test)
            run_tests
            ;;
        install)
            install_project
            ;;
        clean)
            clean_build
            ;;
        package)
            create_package
            ;;
        all)
            install_dependencies
            build_project "$build_type"
            run_tests
            echo ''
            echo 'All operations completed successfully!'
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo "Unknown action: $action"
            echo 'Use "./build.sh help" for usage information.'
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"