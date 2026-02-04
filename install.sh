#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_URL="https://github.com/nicodevvv/console-get-ip-tool.git"
INSTALL_DIR="/tmp/get-ip-tool-install"
BINARY_NAME="get-ip-tool"
INSTALL_PATH="/usr/local/bin/$BINARY_NAME"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   IP Info Tool Installer${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
        elif [ -f /etc/redhat-release ]; then
            OS="redhat"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        echo -e "${RED}Error: Unsupported operating system${NC}"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies
install_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${NC}"
    
    if [[ "$OS" == "macos" ]]; then
        if ! command_exists brew; then
            echo -e "${RED}Homebrew not found. Please install Homebrew first:${NC}"
            echo "Visit: https://brew.sh"
            exit 1
        fi
        
        if ! command_exists cmake; then
            echo -e "${YELLOW}Installing cmake...${NC}"
            brew install cmake
        fi
        
        if ! command_exists curl; then
            echo -e "${YELLOW}Installing curl...${NC}"
            brew install curl
        fi
        
    elif [[ "$OS" == "debian" ]]; then
        if ! command_exists cmake || ! command_exists curl; then
            echo -e "${YELLOW}Installing dependencies...${NC}"
            sudo apt-get update
            sudo apt-get install -y cmake libcurl4-openssl-dev build-essential
        fi
        
    elif [[ "$OS" == "redhat" ]]; then
        if ! command_exists cmake || ! command_exists curl; then
            echo -e "${YELLOW}Installing dependencies...${NC}"
            sudo dnf install -y cmake libcurl-devel gcc make
        fi
    fi
    
    echo -e "${GREEN}✓ All dependencies are installed${NC}\n"
}

# Clone repository
clone_repo() {
    echo -e "${YELLOW}Cloning repository...${NC}"
    
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi
    
    git clone "$REPO_URL" "$INSTALL_DIR"
    echo -e "${GREEN}✓ Repository cloned${NC}\n"
}

# Build project
build_project() {
    echo -e "${YELLOW}Building project...${NC}"
    
    cd "$INSTALL_DIR"
    mkdir -p build
    cd build
    
    cmake ..
    cmake --build .
    
    if [ ! -f "$BINARY_NAME" ]; then
        echo -e "${RED}Error: Build failed${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Project built successfully${NC}\n"
}

# Install binary
install_binary() {
    echo -e "${YELLOW}Installing binary to $INSTALL_PATH...${NC}"
    
    if [ -f "$INSTALL_PATH" ]; then
        echo -e "${YELLOW}Removing existing installation...${NC}"
        sudo rm "$INSTALL_PATH"
    fi
    
    sudo cp "$INSTALL_DIR/build/$BINARY_NAME" "$INSTALL_PATH"
    sudo chmod +x "$INSTALL_PATH"
    
    echo -e "${GREEN}✓ Binary installed${NC}\n"
}

# Cleanup
cleanup() {
    echo -e "${YELLOW}Cleaning up...${NC}"
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✓ Cleanup complete${NC}\n"
}

# Main installation flow
main() {
    detect_os
    install_dependencies
    clone_repo
    build_project
    install_binary
    cleanup
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   Installation Complete! 🎉${NC}"
    echo -e "${GREEN}========================================${NC}\n"
    echo -e "You can now use ${BLUE}$BINARY_NAME${NC} from anywhere:\n"
    echo -e "  ${BLUE}$BINARY_NAME${NC}              # Check your public IP"
    echo -e "  ${BLUE}$BINARY_NAME -ip 8.8.8.8${NC}  # Check specific IP\n"
}

# Run main function
main
