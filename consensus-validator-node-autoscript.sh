#!/bin/bash

# Moniker adını kullanıcıdan al
read -p "Enter your moniker name: " MONIKER_NAME

# Güncelleme ve gerekli paketlerin kurulumu
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# Go 1.22.4 sürümünün kurulumu
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc

# Titan Network dosyasının indirilmesi
git clone https://github.com/nezha90/titan.git

# Klasöre girilmesi ve titand'in derlenmesi
cd titan
go build ./cmd/titand

# Dosyanın hedef dizine taşınması
sudo cp titand /usr/local/bin

# Node için yapılandırma dosyalarının oluşturulması
titand init $MONIKER_NAME --chain-id titan-test-1

# Ağın genesis dosyasının indirilmesi ve taşınması
wget https://raw.githubusercontent.com/nezha90/titan/main/genesis/genesis.json
mv genesis.json ~/.titan/config/genesis.json

# Güncellenmiş addrbook'un indirilmesi
curl -L https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/main/addrbook.json > ~/.titan/config/addrbook.json

# Seed ve peer ayarlarının yapılması
SEEDS="bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656"
PEERS="b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ~/.titan/config/config.toml

# Gas fiyatının ayarlanması
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml

# Pruning ayarının yapılması
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" ~/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" ~/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" ~/.titan/config/app.toml

# Opsiyonel olarak port değişikliği
CUSTOM_PORT=356
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" ~/.titan/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%" ~/.titan/config/app.toml

# Service dosyasının oluşturulması
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

# Node'un başlatılması
sudo systemctl daemon-reload
sudo systemctl enable titan.service
sudo systemctl restart titan.service

# Logların kontrolü için
sudo journalctl -u titan.service -fo cat

echo "Installation and setup completed successfully!"
