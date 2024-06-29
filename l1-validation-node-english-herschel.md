<h1 align="center"> Titan Network L1 Validation Node Ubuntu Installation </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>

* [Titan L1 Validation Node Application Form](https://t.co/8CeQKPNu9x)<br>

Before installation, you need to fill out the Titan L1 Validation Node Application Form above and qualify to install the L1 Validation node. If you qualify, you will receive a unique code. This code is single-use and can be used for one server only. Additionally, we will need an identity code to link the node to our account, which can be obtained from Titan's website.

### Install the prerequisites
```
sudo apt update && sudo apt upgrade -y
sudo apt install screen
```

### Open the necessary ports
```
sudo ufw allow 9000
sudo ufw allow 2345
```

### Download the Titan Network file
```
wget https://github.com/zscboy/titan/releases/latest/download/titan-candidate

```

### Assign the necessary permissions to the file
```
chmod 0755 titan-candidate
```

### Create a folder for Titan in the root directory
```
mkdir /root/titan
```

### Specify the directory we created for Titan
```
export TITAN_METADATAPATH=/root/titan
export TITAN_ASSETSPATHS=/root/titan
```

### Run the node.
```
nohup ./titan-candidate daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0 --code özelkodumuzuburayagiriyoruz > /var/log/candidate.log 2>&1 &
```

### Connect the node to our Titan account, the identity code is required here
```
./titan-candidate bind --hash=identitycodeyazalım https://api-test1.container1.titannet.io/api/v2/device/binding
```

### To check the node, all logs are recorded here
```
nano /var/log/candidate.log
```
### If the node goes offline or loses connection, I recommend using the script below.
```
screen -S titanscript
```

```
nano titanscript.sh
```

```
# It starts an infinite loop.
while true; do
  # The command that will run in the loop.
  nohup ./titan-candidate daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0 --code 5c0db7689c7d40ffae3b4170a850e3a0 > /var/log/candidate.log 2>&1 &

  # The intervals at which the loop will repeat (in seconds)
  sleep 60
done
```
### After pasting our code, we press Ctrl + X, then Y, and finally press Enter.
```
chmod +x titanscript.sh
```

```
./titanscript.sh
```
### To return to the main screen after running
```
ctrl+a aynı anda bastıktan sonra screen ekranı komut modu açılır sonrasında +d ye basarak ana ekrana dönebilirsin
```

### You exited, closed, then reopened it, and wanted to check again
```
screen -r -d titanscript
```

### You have multiple screen commands, and you can't remember their names
```
screen -ls (show all of them with their names, including id) 
```

### You wanted to close any open screen session
```
screen -X -S screenid quit
```
