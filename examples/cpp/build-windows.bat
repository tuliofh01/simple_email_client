@echo off
REM Windows Build Script for SMTP Client
REM This script automatically detects and configures the best available build method

setlocal enabledelayedexpansion

echo SMTP Client Build Script for Windows
echo ====================================

REM Check for Visual Studio
if defined VCINSTALLDIR (
    echo Found Visual Studio installation
    set BUILD_TYPE=vs
    goto :build_vs
)

REM Check for vcpkg
if exist "vcpkg\installed\x64-windows\bin\curl.exe" (
    echo Found vcpkg installation
    set BUILD_TYPE=vcpkg
    goto :setup_vcpkg
)

REM Check for MinGW
where gcc >nul 2>&1
if %errorlevel% == 0 (
    echo Found MinGW/GCC
    set BUILD_TYPE=mingw
    goto :build_mingw
)

REM Check for MSYS2
if exist "C:\msys64\usr\bin\gcc.exe" (
    echo Found MSYS2
    set BUILD_TYPE=msys2
    goto :build_msys2
)

echo No supported build environment found!
echo Please install one of the following:
echo   - Visual Studio 2019/2022 with C++ tools
echo   - MinGW-w64
echo   - MSYS2
echo   - vcpkg (recommended)
pause
exit /b 1

:build_vs
echo Building with Visual Studio...
if not exist "build-vs" mkdir build-vs
cd build-vs
cmake .. -G "Visual Studio 17 2022" -A x64
if %errorlevel% neq 0 (
    cmake .. -G "Visual Studio 16 2019" -A x64
)
cmake --build . --config Release
cd ..
goto :success

:setup_vcpkg
echo Setting up vcpkg environment...
if not exist "vcpkg" (
    echo Cloning vcpkg...
    git clone https://github.com/Microsoft/vcpkg.git
    cd vcpkg
    call bootstrap-vcpkg.bat
    call vcpkg integrate install
    cd ..
)

echo Installing dependencies with vcpkg...
cd vcpkg
call vcpkg install curl[openssl]:x64-windows
cd ..

goto :build_vcpkg

:build_vcpkg
echo Building with vcpkg...
if not exist "build-vcpkg" mkdir build-vcpkg
cd build-vcpkg
cmake .. -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake -A x64
cmake --build . --config Release
cd ..
goto :success

:build_mingw
echo Building with MinGW...
if not exist "build-mingw" mkdir build-mingw
cd build-mingw
cmake .. -G "MinGW Makefiles"
mingw32-make
cd ..
goto :success

:build_msys2
echo Building with MSYS2...
C:\msys64\usr\bin\bash.exe -lc "cd $(cygpath '%cd%') && mkdir -p build-msys2 && cd build-msys2 && cmake .. -G 'Unix Makefiles' && make -j$(nproc)"
goto :success

:success
echo.
echo Build completed successfully!
echo.
echo Executable location:
if exist "build-vs\Release\send_mail.exe" (
    echo   build-vs\Release\send_mail.exe
)
if exist "build-vcpkg\Release\send_mail.exe" (
    echo   build-vcpkg\Release\send_mail.exe
)
if exist "build-mingw\send_mail.exe" (
    echo   build-mingw\send_mail.exe
)
if exist "build-msys2\send_mail.exe" (
    echo   build-msys2\send_mail.exe
)
echo.
echo You can now run the SMTP client!
pause