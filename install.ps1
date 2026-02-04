# IP Info Tool Installer for Windows
# Run with: PowerShell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/nicodevvv/console-get-ip-tool.git"
$INSTALL_DIR = "$env:TEMP\get-ip-tool-install"
$BINARY_NAME = "get-ip-tool.exe"
$INSTALL_PATH = "$env:ProgramFiles\get-ip-tool"

# Colors
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-ColorOutput Blue "========================================"
Write-ColorOutput Blue "   IP Info Tool Installer for Windows"
Write-ColorOutput Blue "========================================"
Write-Output ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-ColorOutput Red "Error: This script must be run as Administrator"
    Write-ColorOutput Yellow "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

# Check for required tools
Write-ColorOutput Yellow "Checking dependencies..."

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-ColorOutput Red "Git is not installed."
    Write-ColorOutput Yellow "Please install Git from: https://git-scm.com/download/win"
    exit 1
}

# Check CMake
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-ColorOutput Red "CMake is not installed."
    Write-ColorOutput Yellow "Please install CMake from: https://cmake.org/download/"
    exit 1
}

# Check for C compiler (Visual Studio or MinGW)
$hasCompiler = $false
if (Get-Command cl -ErrorAction SilentlyContinue) {
    $hasCompiler = $true
    Write-ColorOutput Green "✓ Visual Studio compiler detected"
} elseif (Get-Command gcc -ErrorAction SilentlyContinue) {
    $hasCompiler = $true
    Write-ColorOutput Green "✓ MinGW compiler detected"
}

if (-not $hasCompiler) {
    Write-ColorOutput Red "No C compiler found."
    Write-ColorOutput Yellow "Please install one of the following:"
    Write-ColorOutput Yellow "  - Visual Studio Build Tools: https://visualstudio.microsoft.com/downloads/"
    Write-ColorOutput Yellow "  - MinGW-w64: https://www.mingw-w64.org/"
    exit 1
}

# Check curl library
Write-ColorOutput Yellow "Note: libcurl is required. If build fails, install vcpkg and curl:"
Write-ColorOutput Yellow "  - Install vcpkg: https://vcpkg.io/en/getting-started.html"
Write-ColorOutput Yellow "  - Run: vcpkg install curl"
Write-Output ""

Write-ColorOutput Green "✓ Dependencies check complete"
Write-Output ""

# Clone repository
Write-ColorOutput Yellow "Cloning repository..."
if (Test-Path $INSTALL_DIR) {
    Remove-Item -Recurse -Force $INSTALL_DIR
}
git clone $REPO_URL $INSTALL_DIR
Write-ColorOutput Green "✓ Repository cloned"
Write-Output ""

# Build project
Write-ColorOutput Yellow "Building project..."
Set-Location $INSTALL_DIR
New-Item -ItemType Directory -Force -Path "build" | Out-Null
Set-Location build

try {
    cmake ..
    cmake --build . --config Release
} catch {
    Write-ColorOutput Red "Build failed. Make sure you have libcurl installed."
    Write-ColorOutput Yellow "You may need to use vcpkg:"
    Write-ColorOutput Yellow "  vcpkg install curl:x64-windows"
    Write-ColorOutput Yellow "  cmake .. -DCMAKE_TOOLCHAIN_FILE=[vcpkg root]/scripts/buildsystems/vcpkg.cmake"
    exit 1
}

# Find the built executable
$builtExe = Get-ChildItem -Path . -Recurse -Filter $BINARY_NAME | Select-Object -First 1

if (-not $builtExe) {
    Write-ColorOutput Red "Error: Build failed - executable not found"
    exit 1
}

Write-ColorOutput Green "✓ Project built successfully"
Write-Output ""

# Install binary
Write-ColorOutput Yellow "Installing binary to $INSTALL_PATH..."
if (-not (Test-Path $INSTALL_PATH)) {
    New-Item -ItemType Directory -Force -Path $INSTALL_PATH | Out-Null
}

Copy-Item $builtExe.FullName -Destination "$INSTALL_PATH\$BINARY_NAME" -Force

# Add to PATH if not already there
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentPath -notlike "*$INSTALL_PATH*") {
    Write-ColorOutput Yellow "Adding to system PATH..."
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$currentPath;$INSTALL_PATH",
        "Machine"
    )
    Write-ColorOutput Green "✓ Added to PATH (restart terminal to use)"
}

Write-ColorOutput Green "✓ Binary installed"
Write-Output ""

# Cleanup
Write-ColorOutput Yellow "Cleaning up..."
Set-Location $env:TEMP
Remove-Item -Recurse -Force $INSTALL_DIR
Write-ColorOutput Green "✓ Cleanup complete"
Write-Output ""

Write-ColorOutput Green "========================================"
Write-ColorOutput Green "   Installation Complete! 🎉"
Write-ColorOutput Green "========================================"
Write-Output ""
Write-Output "Restart your terminal, then you can use get-ip-tool:"
Write-Output ""
Write-ColorOutput Blue "  get-ip-tool              " -NoNewline
Write-Output "# Check your public IP"
Write-ColorOutput Blue "  get-ip-tool -ip 8.8.8.8  " -NoNewline
Write-Output "# Check specific IP"
Write-Output ""
