<h1 align="center"> Titan Network Consensus Node Ubuntu Kurulum </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>

### Gereklilikleri yükleyelim
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
```

### Go kurulumunu yapalım 1.22.4 son sürüm
```
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
```

### Titan Network dosyasını çekelim
```
git clone https://github.com/nezha90/titan.git
```

### Dizine girelim ve build edelim
```
cd titan
go build ./cmd/titand
```

### Nodumuzun yapılandırma dosyalarını oluşturmak monikeradiniz kısmını istediğiniz isimle değiştirip kodu girin
```
titand init monikeradiniz --chain-id titan-test-1
```

### Ağın genesis dosyasını indirelim ve taşıyalım
```
wget https://raw.githubusercontent.com/nezha90/titan/main/genesis/genesis.json
mv genesis.json /root/.titan/config/genesis.json
```

### Seed ve Peer ayarlarını yapalım
```
sed -i.bak -e "/^seeds/c seeds = \"bb075c8cc4b7032d506008b68d4192298a09aeea@47.76.107.159:26656\"" -e "/^persistent_peers/c persistent_peers = \"b656a30fd7585c68c72167805784bcd3bed2d67c@8.217.10.76:26656\"" /root/.titan/config/config.toml
```

### Gas ayarı yapalım
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
```

### Pruning ayarı yapalım
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.titan/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.titan/config/app.toml
```

### Port değiştirmek istiyorsanız 35XXX portlarına taşımak için aşağıdaki kodu kullanabilirsiniz zorunlu değil.
```
CUSTOM_PORT=356

sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.titan/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CUSTOM_PORT}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CUSTOM_PORT}91\"%" $HOME/.titan/config/app.toml
```

### Gas ayarı yapalım
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
```

### Gas ayarı yapalım
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml
```
