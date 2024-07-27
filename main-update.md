<h1 align="center"> Titan Network Consensus Node Güncelleme Ubuntu </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>
* [Titan Explorer](https://explorers.titannet.io/en)<br>

### Dosyaları yedekleyelim
```
rsync -av --exclude "data" ~/.titan ~/titan-test-1-config
```

### Ağın yeni versiyonu için gerekli ayarlamaları scriptle yapalım
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/main/update.sh)"
```

### Güncel dosyayı indirelim
```
git clone https://github.com/Titannet-dao/titan-chain.git
```

### titan-chain dizinine girelim
```
cd titan-chain
```

### Build edelim
```
go build ./cmd/titand
```

### titand dosyasını gerekli yere taşıyalım
```
sudo cp titand /usr/local/bin
```

### Restart atalım ve logları kontrol edelim. Logların gelmesi biraz sürebilir bekleyelim
```
sudo systemctl daemon-reload
sudo systemctl restart titan.service
sudo journalctl -u titan.service -fo cat
```

### Buna benzer bir çıktı aldıysanız sorun yok

![hazenov](https://github.com/user-attachments/assets/34cb9cab-ea2a-448b-82e5-687d0e7a2867)

