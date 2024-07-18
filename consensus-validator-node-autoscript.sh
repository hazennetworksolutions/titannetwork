#!/bin/bash

# Load identity code from ~/.bash_profile
source ~/.bash_profile

# Function to display steps
display_step() {
    echo "------------------------------------"
    echo "$1"
    echo "------------------------------------"
    sleep 1
}

# Update and install necessary packages
display_step "Updating and installing necessary packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# Install Go 1.22.4
display_step "Installing Go 1.22.4..."
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Clone Titan Network repository
display_step "Cloning Titan Network repository..."
git clone https://github.com/nezha90/titan.git

# Build Titan
display_step "Building Titan..."
cd titan
go build ./cmd/titand
cp titand /usr/local/bin

# Initialize Titan node (replace "monikername" with your desired moniker)
display_step "Initializing Titan node..."
titand init $monikername --chain-id titan-test-1

# Download and move genesis file
display_step "Downloading genesis file..."
wget https://raw.githubusercontent.com/nezha90/titan/main/genesis/genesis.json
mkdir -p ~/.titan/config/
mv genesis.json ~/.titan/config/genesis.json

# Download and move addrbook file
display_step "Downloading addrbook file..."
curl -L https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/main/addrbook.json > ~/.titan/config/addrbook.json

# Set up seed and peer settings
display_step "Setting up seed and peer settings..."
SEEDS="bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656"
PEERS="b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ~/.titan/config/config.toml

# Set minimum gas price
display_step "Setting minimum gas price..."
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml

# Set up pruning
display_step "Setting up pruning..."
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" ~/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" ~/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" ~/.titan/config/app.toml

# Optionally change ports
CUSTOM_PORT=356
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" ~/.titan/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%" ~/.titan/config/app.toml

# Create systemd service file
display_step "Creating systemd service file..."
sudo bash -c 'cat > /etc/systemd/system/titan.service <<EOF
[Unit]
Description=Titan Daemon
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/titand start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF'

# Start Titan node
display_step "Starting Titan node..."
sudo systemctl daemon-reload
sudo systemctl enable titan.service
sudo systemctl restart titan.service

# Display logs
display_step "Displaying logs..."
sudo journalctl -u titan.service -fo cat

echo "------------------------------------"
echo "Installation and setup completed."
echo "You can check the logs using: sudo journalctl -u titan.service -fo cat"
echo "------------------------------------"
