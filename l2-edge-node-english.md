<h1 align="center"> Titan Network L2 Edge Node Ubuntu Installation </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>

Before installation, you need to visit the website above and sign up. Then go to "console" > "node management" > "get identity code" to obtain the identity code. You will need this shortly. Additionally, we can monitor all our nodes from the "node management" section

### Install the prerequisites
```
sudo apt update && sudo apt upgrade -y
sudo apt install screen
```

### We perform the operations within a screen session
```
screen -S titan
```

### Download and install the Titan Network file
```
wget -c https://github.com/Titannet-dao/titan-node/releases/download/v0.1.18/titan_v0.1.18_linux_amd64.tar.gz -O - | sudo tar -xz -C /usr/local/bin --strip-components=1
```

### Start the node
```
First run after the initial installation 
/usr/local/bin/titan-edge daemon start --init --url https://test-locator.titannet.io:5000/rpc/v0
```

### Connect the node to our Titan account. We'll need the identity code for this step
```
titan-edge bind --hash=writeidentitycodehere https://api-test1.container1.titannet.io/api/v2/device/binding
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
