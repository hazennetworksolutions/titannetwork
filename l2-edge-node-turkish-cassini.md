<h1 align="center"> Titan Network L2 Edge Node Cassini Testnet Ubuntu Kurulum </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>

Kurulumdan önce üstteki websiteye girip kaydolduktan sonra "console" > "node management" > "get identity code" kısmında identity code almanız gerekiyor. Birazdan lazım olacak. Ayrıca tüm nodelarımızı "node management" kısmından kontrol edebiliriz.

### Öncelikle daha önceki testnet aşamalarına katıldığınız bir sunucuya yükleyecekseniz eski nodu durdurup dosyalarını silmeniz gerekiyor
```
rm -rf /root/titan-edge_v0.1.19_89e53b6_linux_amd64
rm -rf /usr/local/bin/titand
rm -rf ~/.titanedge 
rm -rf $TITAN_EDGE_PATH 
rm -rf $EDGE_PATH 
```
### Gereklilikleri yükleyelim
```
sudo apt update && sudo apt upgrade -y
sudo apt install screen
```

### İşlemleri screen içinde yapıyoruz
```
screen -S titan
```

### Titan Network dosyasını indirelim ve içindekileri çıkaralım
```
cd
wget https://github.com/Titannet-dao/titan-node/releases/download/v0.1.20/titan-edge_v0.1.20_246b9dd_linux-amd64.tar.gz
tar -zxvf titan-edge_v0.1.20_246b9dd_linux-amd64.tar.gz
```

### Dosyanın içine girelim ve içindekileri gerekli dizine taşıyalım
```
cd /root/titan-edge_v0.1.20_246b9dd_linux-amd64/
sudo cp titan-edge /usr/local/bin
sudo cp libgoworkerd.so /usr/local/lib
sudo cp libgoworkerd.so /usr/lib/
```

### Nodu çalıştıralım
```
export LD_LIBRARY_PATH=$LD_LIZBRARY_PATH:./libgoworkerd.so
titan-edge daemon start --init --url https://cassini-locator.titannet.io:5000/rpc/v0
```

### Nodu titan hesabımıza bağlayalım identity-code burada lazım
```
titan-edge bind --hash=B8C1AF82-1F14-47D8-89B4-B8525317D309 https://api-test1.container1.titannet.io/api/v2/device/binding
```

### Nodu durdurmak için
```
titan-edge daemon stop
```

### Kurulumdan sonra ana ekrana dönmek için
```
ctrl+a aynı anda bastıktan sonra screen ekranı komut modu açılır sonrasında +d ye basarak ana ekrana dönebilirsin
```

### Çıktın kapattın sonrasında yeniden açtın ve kontrol etmek istedin
```
screen -r -d titan
```

### Birden fazla screen komutun var adını hatırlayamadın
```
screen -ls (hepsini görüntüler id ile birlikte) 
```

### Açık olan herhangi bir screeni kapatmak istedin
```
screen -X -S screenid quit
```
