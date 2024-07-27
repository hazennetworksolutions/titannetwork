#!/bin/bash

# Enter user directory
cd ~ || exit

# Stop old titan program
systemctl stop titan.service

# Back up the .titan directory. If something goes wrong in the middle, you can use the backup to restore and then execute again.
mv ~/.titan ~/titan_bak

# Copy directory and other information to the new path
rsync -av --exclude "data" ~/titan_bak/* ~/.titan

# Delete existing executable program
# shellcheck disable=SC2046
rm $(which titand)

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

# Update config/client.toml chain-id
echo '# This is a TOML config file.
# For more information, see https://github.com/toml-lang/toml

###############################################################################
###                           Client Configuration                            ###
###############################################################################

# The network chain ID
chain-id = "titan-test-2"
# The keyring s backend, where the keys are stored (os|file|kwallet|pass|test|memory)
keyring-backend = "os"
# CLI output format (text|json)
output = "text"
# <host>:<port> to Tendermint RPC interface for this chain
node = "tcp://localhost:26657"
# Transaction broadcasting mode (sync|async)
broadcast-mode = "sync"' > ~/.titan/config/client.toml
