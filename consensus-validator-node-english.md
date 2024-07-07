<h1 align="center"> Titan Network Consensus Node Ubuntu Installation </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>
* [Titan Explorer](https://explorers.titannet.io/en)<br>

### Currently, only those who have participated in the testnet before can install because the discord faucet system is not yet working. If you have previously earned points, request your test tokens from the address below.
https://faucet.titannet.io/

### For those who will only stake and not set up a validator, our validator's address is: titanvaloper1svtz89c2xpz0l3lyscvmsx4eat4kgml0mn7phn
https://staking.titannet.io/

### Install the requirements
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
```

### Install Go 1.22.4, the latest version
```
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
```

### Download the Titan Network file
```
git clone https://github.com/nezha90/titan.git
```

### Enter the directory and build it
```
cd titan
go build ./cmd/titand
```

### Move the file to the target directory
```
cp titand /usr/local/bin
```

### Create the configuration files for our node, replace "monikername" with your desired name and enter the command
```
titand init monikername --chain-id titan-test-1
```

### Download the network's genesis file and move it
```
wget https://raw.githubusercontent.com/nezha90/titan/main/genesis/genesis.json
mv genesis.json /root/.titan/config/genesis.json
```

### Download the updated addrbook
```
curl -L https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/main/addrbook.json > $HOME/.titan/config/addrbook.json
```

### Set up the seed and peer settings
```
SEEDS="bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656"
PEERS="b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.titan/config/config.toml
```

### Set up the gas price
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
```

### Set up pruning
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.titan/config/app.toml
```

### If you want to change the port to 35XXX ports, you can use the following code, it's optional
```
CUSTOM_PORT=356

sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.titan/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%" $HOME/.titan/config/app.toml
```

### Set up the gas price
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
```

### Create the service file
```
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
```

### Start the node. It takes some time to connect to peers, so please wait
```
sudo systemctl daemon-reload
sudo systemctl enable titan.service
sudo systemctl restart titan.service
```

### To check the logs
```
sudo journalctl -u titan.service -fo cat
```

### create a wallet, replace walletname with your desired wallet name
```
titand keys add walletname
```

### If you want to import a wallet, replace walletname with your desired wallet name
```
titand keys add walletname --recover
```

### Get the faucet from Discord. After receiving and pairing the faucet, let's create the validator
```
titand tx staking create-validator \
  --amount=1000000uttnt \
  --pubkey=$(titand tendermint show-validator) \
  --chain-id=titan-test-1 \
  --from=walletname \
  --moniker "monikername" \
  --identity "optional" \
  --details "optional" \
  --website "optional" \
  --commission-max-change-rate=0.01 \
  --commission-max-rate=1.0 \
  --commission-rate=0.07 \
  --min-self-delegation=1 \
  --fees 500uttnt \
  --node=http://localhost:35657
  -y
```

### Let's stake
```
titand tx staking delegate $(titand keys show walletname --bech val -a) 1000000uttnt --from walletname --chain-id titan-test-1 --gas-prices=0.025uttnt --gas-adjustment=1.5 --gas=auto --node=http://localhost:35657 -y
```
