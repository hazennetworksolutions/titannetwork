<h1 align="center"> Titan Network Consensus Node Ubuntu Installation </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>
* [Titan Explorer](https://explorers.titannet.io/en)<br>

### Discord faucet is working now

### Install the requirements.
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
```

### Install Go 1.22.4, the latest version.
```
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
```

###  Download the file, move it to the necessary locations, configure it, and install the Cosmovisor application.

```
git clone https://github.com/Titannet-dao/titan-chain.git
cd titan-chain
git fetch origin
git checkout origin/main
go build ./cmd/titand
```
```
mkdir -p /root/.titan/cosmovisor/genesis/bin
cp -r /root/titan-chain/titand /root/.titan/cosmovisor/genesis/bin/
```
```
sudo ln -sfn $HOME/.titan/cosmovisor/genesis $HOME/.titan/cosmovisor/current
sudo ln -sfn $HOME/.titan/cosmovisor/current/bin/titand /usr/local/bin/titand
```
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

### Create the service file
```
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
```
```
sudo systemctl daemon-reload
sudo systemctl enable titan
```

### Create the configuration files for our node, replace "monikername" with your desired name and enter the command.
```
titand init "monikername" --chain-id titan-test-3
```

### Download the network's genesis file and move it.
```
wget -P ~/. https://raw.githubusercontent.com/Titannet-dao/titan-chain/main/genesis/genesis.json
mv ~/genesis.json ~/.titan/config/genesis.json
```

### Download the updated addrbook.
```
wget -P ~/. https://raw.githubusercontent.com/Titannet-dao/titan-chain/main/addrbook/addrbook.json
mv ~/addrbook.json ~/.titan/config/addrbook.json
```

### Set up the gas price.
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
```

### Set up the seed and peer settings.
```
SEEDS="bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656"
PEERS="b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.titan/config/config.toml
```

### Set up pruning.
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.titan/config/app.toml
```


### If you want to change the port to 352XX ports, you can use the following code, it's optional.
```
CUSTOM_PORT=352

sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.titan/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%" $HOME/.titan/config/app.toml
```

### Start the node. It takes some time to connect to peers, so please wait
```
sudo systemctl restart titan
sudo journalctl -u titan -f --no-hostname -o cat
```

### Create a wallet, replace walletname with your desired wallet name
```
titand keys add walletname
```

### If you want to import a wallet, replace walletname with your desired wallet name
```
titand keys add walletname --recover
```

### We get the faucet from the Titan Discord #faucet channel. $request titanwalletadress


### Create the validator
```
wardend tx staking create-validator /root/validator.json \
    --from=walletname \
    --chain-id=buenavista-1 \
    --fees=500uward \
    --node=http://localhost:35257
```

### Let's stake
```
wardend tx staking delegate valoperadress amount000000uward \
--chain-id buenavista-1 \
--from "walletname" \
--fees 500uward \
--node=http://localhost:35257
```

### Unjail code
```
titand tx slashing unjail --from wallet-name --chain-id titan-test-3 --fees 500uttnt --node=http://localhost:35257 -y
```
### To completely remove the Warden node
```
sudo systemctl stop titan
sudo systemctl disable titan
sudo rm -rf /etc/systemd/system/titan.service
sudo rm $(which titan)
sudo rm -rf $HOME/.titan
sed -i "/WARDEN_/d" $HOME/.bash_profile
```
