<h1 align="center"> Titan Network L1 Validation Node Ubuntu Kurulum </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>

* [Titan L1 Validation Node Başvuru Formu](https://t.co/8CeQKPNu9x)<br>

Kurulumdan önce üstteki Titan L1 Validation Node Başvuru Formunu doldurmanız ve L1 Validation node kurmaya hak kazanmanız gerekiyor. Eğer hak kazanırsanız size özel bir kod gönderiliyor. Bu kod tek kullanımlık ve 1 tane sunucu için kullanılabiliyor. Ayrıca nodu hesabımıza bağlamak için de identity code ihtiyacımız olacak.

### Gereklilikleri yükleyelim
```
sudo apt update && sudo apt upgrade -y
sudo apt install screen
```

### Gerekli portları açalım
```
sudo ufw allow 9000
sudo ufw allow 2345
```

### Titan Network dosyasını indirelim
```
wget https://github.com/zscboy/titan/releases/latest/download/titan-candidate

```

### Dosyaya gerekli izinleri atayalım
```
chmod 0755 titan-candidate
```

### Titan için root dizinine ayrı bir dosya oluşturalım
```
mkdir /root/titan
```

### Oluşturduğumuz dosyayı titan için belirtelim
```
export TITAN_METADATAPATH=/root/titan
export TITAN_ASSETSPATHS=/root/titan
```

### Nodu çalıştırmak için
```
nohup ./titan-candidate daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0 --code özelkodumuzuburayagiriyoruz > /var/log/candidate.log 2>&1 &
```

### Nodu titan hesabımıza bağlayalım identity-code burada lazım
```
./titan-candidate bind --hash=identitycodeyazalım https://api-test1.container1.titannet.io/api/v2/device/binding
```

### Nodu kontrol etmek için. tüm loglar burada kaydediliyor
```
nano /var/log/candidate.log
```
### Eğer node offline oluyorsa bağlantısı kopuyorsa aşağıdaki scripti kullanmanızı öneririm
```
screen -S titanscript
```

```
nano titanscript.sh
```

```
# Sonsuz bir döngü başlatır
while true; do
  # Döngüde çalışacak olan komut
  nohup ./titan-candidate daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0 --code 5c0db7689c7d40ffae3b4170a850e3a0 > /var/log/candidate.log 2>&1 &

  # Hangi periyotlarla döngünün tekrarlanacağı (saniye olarak)
  sleep 60
done
```

```
chmod +x titanscript.sh
```

```
./titanscript.sh
```
