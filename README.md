# IP Info Tool Console

A lightweight command-line tool written in C that retrieves geographical and network information about IP addresses using the ip-api.com API.

## Features

- Query information about your public IP address
- Query information about any specific IP address
- Display results in a clean, formatted table
- Fast and lightweight (written in C)
- Uses libcurl for HTTP requests

## Quick Install

### Option 1: Download Pre-compiled Binary (Easiest)

Download the latest release for your platform from [Releases](https://github.com/nicodevvv/console-get-ip-tool/releases):

- **Linux (x64)**: `get-ip-tool-linux-x64.tar.gz`
- **macOS (Apple Silicon)**: `get-ip-tool-macos-arm64.tar.gz`
- **Windows (x64)**: `get-ip-tool-windows-x64.zip`

**Installation after download:**

**macOS/Linux:**
```bash
# Extract
tar -xzf get-ip-tool-*.tar.gz

# Move to system path
sudo mv get-ip-tool /usr/local/bin/
sudo chmod +x /usr/local/bin/get-ip-tool
```

**Windows:**
```powershell
# Extract the zip file, then run as Administrator:
Move-Item get-ip-tool.exe "$env:ProgramFiles\get-ip-tool\"
# Add to PATH manually via System Environment Variables
```

### Option 2: Automatic Installer Script

### macOS / Linux

Install with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/nicodevvv/console-get-ip-tool/main/install.sh | bash
```

The installer will:
- Detect your operating system
- Install required dependencies (CMake, libcurl)
- Clone and build the project
- Install the binary to `/usr/local/bin`
- Clean up temporary files

### Windows

**Prerequisites:**
- [Git](https://git-scm.com/download/win)
- [CMake](https://cmake.org/download/)
- A C compiler: [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/) or [MinGW-w64](https://www.mingw-w64.org/)
- [vcpkg](https://vcpkg.io/en/getting-started.html) for libcurl

**Installation:**

1. Install curl library via vcpkg:
```powershell
vcpkg install curl:x64-windows-static
```

2. Run the installer as Administrator:
```powershell
# Download and run
irm https://raw.githubusercontent.com/nicodevvv/console-get-ip-tool/main/install.ps1 | iex

# Or download first, then run
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/nicodevvv/console-get-ip-tool/main/install.ps1" -OutFile "install.ps1"
PowerShell -ExecutionPolicy Bypass -File install.ps1
```

The installer will automatically add the tool to your PATH.

### Uninstall

**macOS/Linux:**
```bash
sudo rm /usr/local/bin/get-ip-tool
```

**Windows:**
```powershell
# Run as Administrator
Remove-Item "$env:ProgramFiles\get-ip-tool" -Recurse -Force
# Manually remove from PATH in System Environment Variables
```

## Prerequisites

Before building this tool, ensure you have the following installed:

- CMake (version 3.10 or higher)
- A C compiler (GCC, Clang, or MSVC)
- libcurl development libraries

### Installing Prerequisites

**macOS:**
```bash
brew install cmake curl
```

**Ubuntu/Debian:**
```bash
sudo apt-get install cmake libcurl4-openssl-dev build-essential
```

**Fedora/RHEL:**
```bash
sudo dnf install cmake libcurl-devel gcc make
```

**Windows:**
- Install [CMake](https://cmake.org/download/)
### macOS / Linux

1. Clone or navigate to the project directory:
```bash
git clone https://github.com/nicodevvv/console-get-ip-tool.git
cd console-get-ip-tool
```

2. Create a build directory and navigate to it:
```bash
mkdir -p build
cd build
```

3. Run CMake to configure the project:
```bash
cmake ..
```

4. Build the executable:
```bash
cmake --build .
```

The executable `get-ip-tool` will be created in the build directory.

### Windows

1. Clone the repository:
```powershell
git clone https://github.com/nicodevvv/console-get-ip-tool.git
cd console-get-ip-tool
```

2. Configure with CMake (using vcpkg toolchain):
```powershell
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=[path-to-vcpkg]/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows-static
```

3. Build:
```powershell
cmake --build . --config Release
```

The executable `get-ip-tool.exe` will be in the `Release` sub
4. Build the executable:
```bash
cmake --build .
```

The executable `get-ip-tool` will be created in the build directory.

## Usage

### Query Your Public IP
```bash
./get-ip-tool
```

### Query a Specific IP Address
```bash
./get-ip-tool -ip 8.8.8.8
```

### Example Output
```
┌───────────┬───────────────────────────┐
│ IP        │ 8.8.8.8                   │
│ País      │ United States             │
│ Región    │ California                │
│ Ciudad    │ Mountain View             │
│ ISP       │ Google LLC                │
└───────────┴───────────────────────────┘
```

## Installing for System-Wide Use

To use the tool from anywhere in your terminal without navigating to the project directory:

### Method 1: Copy to System Binary Directory (Recommended)

**macOS/Linux:**
```bash
# From the build directory
sudo cp get-ip-tool /usr/local/bin/

# Make it executable (if needed)
sudo chmod +x /usr/local/bin/get-ip-tool
```

After this, you can run the tool from anywhere:
```bash
get-ip-tool
get-ip-tool -ip 1.1.1.1
```

### Method 2: Add to PATH

Add the build directory to your PATH environment variable:

**For Bash (~/.bashrc or ~/.bash_profile):**
```bash
echo 'export PATH="$PATH:$(pwd)"' >> ~/.bashrc
source ~/.bashrc
```

**For Zsh (~/.zshrc):**
```bash
echo 'export PATH="$PATH:$(pwd)"' >> ~/.zshrc
source ~/.zshrc
```

**For Fish (~/.config/fish/config.fish):**
```fish
set -Ua fish_user_paths (pwd)
```

### Method 3: Create a Symlink

```bash
# From the build directory
sudo ln -s $(pwd)/get-ip-tool /usr/local/bin/get-ip-tool
```

## Uninstalling

If you installed using Method 1 or 3:
```bash
sudo rm /usr/local/bin/get-ip-tool
```

If you used Method 2, simply remove the export line from your shell configuration file.

## How It Works

1. The tool uses libcurl to make HTTP requests to the ip-api.com API
2. If no IP is specified, the API automatically detects your public IP
3. The JSON response is parsed using a simple string-matching function
4. Results are formatted and displayed in a clean table format

## API Information

This tool uses the free tier of [ip-api.com](http://ip-api.com/), which allows:
- 45 requests per minute
- Non-commercial use
- No API key required

## License

This project is provided as-is for educational and personal use.

## Contributing

Feel free to submit issues and enhancement requests!
