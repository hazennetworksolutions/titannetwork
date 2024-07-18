<h1 align="center"> Titan Network Consensus Node Automatic Ubuntu Installation </h1>

* [Titan Website](https://test1.titannet.io/login)<br>
* [Titan Discord](https://discord.com/invite/titannet)<br>
* [Titan Telegram](https://t.me/titannet_dao)<br>


### Replace the part that says writeyourmonikername with your moniker name. Then run the command.

```
curl -sSf https://raw.githubusercontent.com/hazennetworksolutions/titannetwork/main/consensus-validator-node-autoscript.sh | bash -s -- --monikername=writeyourmonikername
```
### To check the logs
```
sudo journalctl -u titan.service -fo cat
```

### create a wallet, replace walletname with your desired wallet name
```
titand keys add walletname
```

### If you want to import a wallet, replace walletname with your desired wallet name
```
titand keys add walletname --recover
```

### Get the faucet from Discord. After receiving and pairing the faucet, let's create the validator
```
titand tx staking create-validator \
  --amount=1000000uttnt \
  --pubkey=$(titand tendermint show-validator) \
  --chain-id=titan-test-1 \
  --from=walletname \
  --moniker "monikername" \
  --identity "optional" \
  --details "optional" \
  --website "optional" \
  --commission-max-change-rate=0.01 \
  --commission-max-rate=1.0 \
  --commission-rate=0.07 \
  --min-self-delegation=1 \
  --fees 500uttnt \
  --node=http://localhost:35657
  -y
```

### Let's stake
```
titand tx staking delegate $(titand keys show walletname --bech val -a) 1000000uttnt --from walletname --chain-id titan-test-1 --gas-prices=0.025uttnt --gas-adjustment=1.5 --gas=auto --node=http://localhost:35657 -y
```
