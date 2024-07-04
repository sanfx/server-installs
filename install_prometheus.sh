#!/bin/bash

# Detect OS and convert to lowercase
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Determine OS type
if [[ "$OS" == "darwin" ]]; then
    OS="darwin"
elif [[ "$OS" == "linux" ]]; then
    OS="linux"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Determine architecture
case "$ARCH" in
    x86_64)
        ARCH="amd64"
        ;;
    armv7l)
        ARCH="armv7"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Construct download URL
VERSION="2.41.0" # Replace with the desired Prometheus version
URL="https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.${OS}-${ARCH}.tar.gz"

# Output the download URL
echo "Download URL: $URL"

# Download Prometheus
curl -LO $URL

# Extract the tarball
tar -xzf prometheus-${VERSION}.${OS}-${ARCH}.tar.gz

echo "Prometheus downloaded and extracted successfully."
