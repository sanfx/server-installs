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
filename="prometheus-${VERSION}.${OS}-${ARCH}.tar.gz"
URL="https://github.com/prometheus/prometheus/releases/download/v${VERSION}/${filename}"

# Output the download URL
echo "Download URL: $URL"

# Download Prometheus
curl -LO $URL



# Extract the tarball
tar -xzf ${filename}

echo "Prometheus downloaded and extracted successfully."

EXTRACT_DIR=$(tar -tzf $filename | head -1 | cut -f1 -d"/")

cd ${EXTRACT_DIR}
echo "Changed directory to $PWD"
echo "Moving 'prometheus' to /usr/local/bin/"
sudo mv -vf prometheus /usr/local/bin/
echo "Moving 'promtool' to /usr/local/bin/"
sudo mv -vf promtool /usr/local/bin/

sudo chmod +x /usr/local/bin/prometheus
sudo chmod +x /usr/local/bin/promtool


sudo mkdir -p /etc/prometheus
echo "copying 'consoles', 'console_libraries' and 'prometheus.yml' to /etc/prometheus/"
sudo cp -r consoles console_libraries prometheus.yml /etc/prometheus/

sudo cp ./prometheus.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl start prometheus

