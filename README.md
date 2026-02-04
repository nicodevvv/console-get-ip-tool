# IP Info Tool Console

A lightweight command-line tool written in C that retrieves geographical and network information about IP addresses using the ip-api.com API.

## Features

- Query information about your public IP address
- Query information about any specific IP address
- Display results in a clean, formatted table
- Fast and lightweight (written in C)
- Uses libcurl for HTTP requests

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
sudo apt-get install cmake libcurl4-openssl-dev
```

**Fedora/RHEL:**
```bash
sudo dnf install cmake libcurl-devel
```

## Building the Project

1. Clone or navigate to the project directory:
```bash
cd ip-info-tool-console
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
