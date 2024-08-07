#!/bin/bash

# Enter user directory
cd ~ || exit

# Stop old titan program
systemctl stop titan

# Back up the .titan directory. If something goes wrong in the middle, you can use the backup to restore and then execute again.
mv ~/.titan ~/titan_bak_08_07

# Copy directory and other information to the new path
rsync -av --exclude "data" ~/titan_bak_08_07/* ~/.titan

# Download new genesis file
wget -P ~/. https://raw.githubusercontent.com/Titannet-dao/titan-chain/main/genesis/genesis.json

# Replace new genesis file
mv ~/genesis.json ~/.titan/config/genesis.json

mkdir ~/.titan/data
# Build data/priv_validator_state.json 文件
echo '{
  "height": "0",
  "round": 0,
  "step": 0
}' > ~/.titan/data/priv_validator_state.json


systemctl start titan
