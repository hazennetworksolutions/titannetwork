#!/bin/bash

set -e

# Step 1: Install necessary libraries and tools
echo "Step 1: Installing necessary libraries and tools..."
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# Step 2: Install Go 1.22.4
echo "Step 2: Installing Go 1.22.4..."
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc

# Step 3: Download Titan Network code
echo "Step 3: Downloading Titan Network code..."
git clone https://github.com/nezha90/titan.git

# Step 4: Enter directory and build
echo "Step 4: Building Titan code..."
cd titan
go build ./cmd/titand

# Step 5: Move the built file to the target directory
echo "Step 5: Moving titand to /usr/local/bin..."
sudo cp titand /usr/local/bin

# Step 6: Create configuration files
echo "Step 6: Creating configuration files..."
titand init monikername --chain-id titan-test-1

# Step 7: Download and move genesis file
echo "Step 7: Downloading genesis file..."
wget https://raw.githubusercontent.com/nezha90/titan/main/genesis/genesis.json
mv genesis.json $HOME/.titan/config/genesis.json

# Step 8: Download updated addrbook
echo "Step 8: Downloading addrbook..."
curl -L https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/main/addrbook.json > $HOME/.titan/config/addrbook.json

# Step 9: Set up seed and peer settings
echo "Step 9: Setting up seed and peer settings..."
SEEDS="bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656"
PEERS="b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.titan/config/config.toml

# Step 10: Set up gas price
echo "Step 10: Setting up gas price..."
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml

# Step 11: Set up pruning
echo "Step 11: Setting up pruning..."
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.titan/config/app.toml

# Step 12: Change port settings (Optional)
echo "Step 12: Changing port settings (Optional)..."
CUSTOM_PORT=356
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.titan/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%" $HOME/.titan/config/app.toml

# Step 13: Create service file
echo "Step 13: Creating service file..."
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

# Step 14: Start the node
echo "Step 14: Starting the node..."
sudo systemctl daemon-reload
sudo systemctl enable titan.service
sudo systemctl restart titan.service

# Step 15: Check the logs
echo "Step 15: Checking the logs..."
sudo journalctl -u titan.service -fo cat
