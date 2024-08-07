#!/bin/bash

# Load identity code from ~/.bash_profile
source ~/.bash_profile

# Remove old files
echo "Removing old files..."
rm -rf /root/titan-edge_v0.1.19_89e53b6_linux_amd64
rm -rf /usr/local/bin/titand
rm -rf ~/.titanedge 
rm -rf $TITAN_EDGE_PATH 
rm -rf $EDGE_PATH 
echo "File removal completed."

# Update packages and install necessary software
echo "Updating packages and installing necessary software..."
sudo apt update && sudo apt upgrade -y
sudo apt install screen -y
echo "Package update and software installation completed."

# Create a screen session for Titan
echo "Creating a screen session for Titan..."
screen -S titan -d -m
echo "Screen session created."

# Download and extract Titan files
echo "Downloading and extracting Titan files..."
cd
wget https://github.com/Titannet-dao/titan-node/releases/download/v0.1.20/titan-edge_v0.1.20_246b9dd_linux-amd64.tar.gz
tar -zxvf titan-edge_v0.1.20_246b9dd_linux-amd64.tar.gz
echo "File download and extraction completed."

# Copy Titan files
echo "Copying Titan files..."
cd /root/titan-edge_v0.1.20_246b9dd_linux-amd64/
sudo cp titan-edge /usr/local/bin
sudo cp libgoworkerd.so /usr/local/lib
sudo cp libgoworkerd.so /usr/lib/
echo "File copying completed."

# Set environment variable and start Titan node
echo "Setting environment variable and starting Titan node..."
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Start Titan node once
echo "Starting Titan node..."
titan-edge daemon start --init --url https://cassini-locator.titannet.io:5000/rpc/v0 &
PID=$!
sleep 10  # Wait 10 seconds to ensure the node is running
kill $PID
echo "Titan node started and stopped."

# Run Titan bind command with identity code
echo "Running Titan bind command with identity code: $identitycode"
titan-edge bind --hash=$identitycode https://api-test1.container1.titannet.io/api/v2/device/binding
echo "Titan bind completed."

# Restart Titan daemon
echo "Restarting Titan daemon..."
titan-edge daemon start

echo "Script completed successfully."
