#!/bin/bash
LOG_FILE="/var/log/titan_node_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

printGreen() {
    echo -e "\033[32m$1\033[0m"
}

printLine() {
    echo "------------------------------"
}

# Function to print the node logo
function printNodeLogo {
    echo -e "\033[32m"
    echo "          
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
█████████████████████████████████████                          █████████████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
██████████████████████████████             █             █            ██████████████████████████████
████████████████████████████           █████             ████           ████████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ███████            ██████          ███████████████████████████
████████████████████████████          ██████████         ██████          ███████████████████████████
████████████████████████████          █████████████      ██████          ███████████████████████████
████████████████████████████             █████████████     ████          ███████████████████████████
████████████████████████████          █     █████████████     █          ███████████████████████████
████████████████████████████          █████     ████████████             ███████████████████████████
████████████████████████████          ██████       ████████████          ███████████████████████████
████████████████████████████          ██████          █████████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████            ████             ███            ████████████████████████████
██████████████████████████████                                        ██████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
█████████████████████████████████████                           ████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
Hazen Network Solutions 2024 All rights reserved."
    echo -e "\033[0m"
}

# Show the node logo
printNodeLogo

# User confirmation to proceed
echo -n "Type 'yes' to start the installation Titan Network v2.0.0 with Cosmovisor and press Enter: "
read user_input

if [[ "$user_input" != "yes" ]]; then
  echo "Installation cancelled."
  exit 1
fi

# Function to print in green
printGreen() {
  echo -e "\033[32m$1\033[0m"
}

printGreen "Starting installation..."
sleep 1

printGreen "If there are any, clean up the previous installation files"

sudo systemctl stop titan
sudo systemctl disable titan
sudo rm -rf /etc/systemd/system/titan.service
sudo rm $(which titan)
sudo rm -rf $HOME/.titan
sed -i "/TITAN_/d" $HOME/.bash_profile

# Update packages and install dependencies
printGreen "1. Updating and installing dependencies..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# User inputs
read -p "Enter your MONIKER: " MONIKER
echo 'export MONIKER='$MONIKER
read -p "Enter your PORT (2-digit): " PORT
echo 'export PORT='$PORT

# Setting environment variables
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export TITAN_CHAIN_ID=\"titan-test-4\"" >> $HOME/.bash_profile
echo "export TITAN_PORT=$PORT" >> $HOME/.bash_profile
source $HOME/.bash_profile

printLine
echo -e "Moniker:        \e[1m\e[32m$MONIKER\e[0m"
echo -e "Chain ID:       \e[1m\e[32m$TITAN_CHAIN_ID\e[0m"
echo -e "Node custom port:  \e[1m\e[32m$TITAN_PORT\e[0m"
printLine
sleep 1

# Install Go
printGreen "2. Installing Go..." && sleep 1
cd $HOME
VER="1.23.0"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=\$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

# Version check
echo $(go version) && sleep 1

# Download Warden protocol binary
printGreen "3. Downloading Titan binary and setting up..." && sleep 1
wget -P /root https://github.com/Titannet-dao/titan-chain/releases/download/v0.3.0/titand_0.3.0-1_g167b7fd6.tar.gz
tar -xvzf /root/titand_0.3.0-1_g167b7fd6.tar.gz -C /root
rm -rf /root/titand_0.3.0-1_g167b7fd6.tar.gz
mv /root/titand_0.3.0-1_g167b7fd6/titand /root/.titan/cosmovisor/genesis/bin/
rm -rf /root/titand_0.3.0-1_g167b7fd6/
chmod +x /root/.titan/cosmovisor/genesis/bin/titand
wget -P /root https://github.com/Titannet-dao/titan-chain/releases/download/v0.3.0/titand_0.3.0-1_g167b7fd6.tar.gz
tar -xvzf /root/titand_0.3.0-1_g167b7fd6.tar.gz -C /root
rm -rf /root/titand_0.3.0-1_g167b7fd6.tar.gz
mv /root/titand_0.3.0-1_g167b7fd6/titand $HOME/go/bin
rm -rf /root/titand_0.3.0-1_g167b7fd6/
chmod +x $HOME/go/bin/titand

# Create symlinks
printGreen "4. Creating symlinks..." && sleep 1
sudo ln -sfn $HOME/.titan/cosmovisor/genesis $HOME/.titan/cosmovisor/current
sudo ln -sfn $HOME/.titan/cosmovisor/current/bin/titand /usr/local/bin/titand

# Installi Cosmovisor
printGreen "5. Installing Cosmovisor..." && sleep 1
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0

# Create service file
printGreen "6. Creating service file..." && sleep 1
sudo tee /etc/systemd/system/titan.service > /dev/null << EOF
[Unit]
Description=titan node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=${HOME}/.titan"
Environment="DAEMON_NAME=titand"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.titan/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable titan

# Initialize the node
printGreen "7. Initializing the node..."
titand config set client chain-id ${TITAN_CHAIN_ID}
titand config set client keyring-backend test
titand config set client node tcp://localhost:${TITAN_PORT}657
titand init ${MONIKER} --chain-id ${TITAN_CHAIN_ID}

# Download genesis and addrbook files
printGreen "8. Downloading genesis and addrbook..."
curl -Ls https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/refs/heads/main/genesis.json > $HOME/.titan/config/genesis.json
wget -O $HOME/.titan/config/addrbook.json "https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/refs/heads/main/addrbook.json"

# Configure gas prices and ports
printGreen "9. Configuring custom ports and gas prices..." && sleep 1
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
sed -i.bak -e "s%:1317%:${TITAN_PORT}317%g; s%:8080%:${TITAN_PORT}080%g; s%:9090%:${TITAN_PORT}090%g; s%:9091%:${TITAN_PORT}091%g; s%:8545%:${TITAN_PORT}545%g; s%:8546%:${TITAN_PORT}546%g; s%:6065%:${TITAN_PORT}065%g" $HOME/.titan/config/app.toml

# Configure P2P and ports
sed -i.bak -e "s%:26658%:${TITAN_PORT}658%g; s%:26657%:${TITAN_PORT}657%g; s%:6060%:${TITAN_PORT}060%g; s%:26656%:${TITAN_PORT}656%g; s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${TITAN_PORT}656\"%" $HOME/.titan/config/config.toml

# Set up seeds and peers
printGreen "10. Setting up peers and seeds..." && sleep 1
SEEDS="bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656"
PEERS="b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.titan/config/config.toml

# Pruning Settings
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.titan/config/app.toml

# Download the snapshot
# printGreen "12. Downloading snapshot and starting node..." && sleep 1





# Start the node
printGreen "13. Starting the node..."
sudo systemctl restart titan

# Check node status
printGreen "14. Checking node status..."
sudo journalctl -u titan -f --no-hostname -o cat

# Verify if the node is running
if systemctl is-active --quiet titan; then
  echo "The node is running successfully! Logs can be found at /var/log/titan_node_install.log"
else
  echo "The node failed to start. Logs can be found at /var/log/titan_node_install.log"
fi
