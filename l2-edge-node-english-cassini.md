<h1 align="center"> Titan Network L2 Edge Node Cassini Testnet Ubuntu Installation </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>

Before installation, after registering on the website above, you need to go to "console" > "node management" > "get identity code" to obtain an identity code. You'll need this shortly. Additionally, you can manage all nodes from the "node management" section.

### If you are installing on a server where you participated in previous testnet stages, you need to stop the old node and delete its files.
```
rm -rf ~/.titanedge 
rm -rf $TITAN_EDGE_PATH 
rm -rf $EDGE_PATH 
```
### Let's install the prerequisites.
```
sudo apt update && sudo apt upgrade -y
sudo apt install screen
```

### Perform the operations within a screen session.
```
screen -S titan
```

### Download the Titan Network file and extract its contents.
```
cd
wget https://github.com/Titannet-dao/titan-node/releases/download/v0.1.20/titan-edge_v0.1.20_246b9dd_linux-amd64.tar.gz
tar -zxvf titan-edge_v0.1.20_246b9dd_linux-amd64.tar.gz
```

### Navigate into the directory and move the contents to the required directory.
```
cd /root/titan-edge_v0.1.19_89e53b6_linux_amd64
sudo cp titan-edge /usr/local/bin
sudo cp libgoworkerd.so /usr/local/lib
sudo cp libgoworkerd.so /usr/lib/
```

### Start the node.
```
export LD_LIBRARY_PATH=$LD_LIZBRARY_PATH:./libgoworkerd.so
titan-edge daemon start --init --url https://cassini-locator.titannet.io:5000/rpc/v0
```

### Connect the node to our Titan account; the identity code is needed here.
```
titan-edge bind --hash=identitycode https://api-test1.container1.titannet.io/api/v2/device/binding
```

### If the node stops or encounters an issue, here's how to restart it
```
titan-edge daemon start
```

### To stop the node
```
titan-edge daemon stop
```

### To return to the main screen after installation
```
pressing ctrl+a simultaneously opens the command mode in the screen, then press +d to return to the main screen.
```

### You exited, closed, then reopened it, and wanted to check again
```
screen -r -d titan
```

### You have multiple screen commands, and you can't remember their names
```
screen -ls (show all of them with their names, including id) 
```

### You wanted to close any open screen session
```
screen -X -S screenid quit
```
