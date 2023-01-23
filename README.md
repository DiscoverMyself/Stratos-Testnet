<div classname="logo">
    <p align="center">
    <img height="400" height="auto" src="https://user-images.githubusercontent.com/78480857/213947479-83fd5d15-ff7d-46bf-9a03-65493d53b22f.jpg">
</div>


# STRATOS testnet

- [Website](https://www.thestratos.org/)

- [Explorer](https://explorer-tropos.thestratos.org/)

- [Telegram](https://t.me/StratosCommunity)

- [Discord](https://discord.com/invite/tpQGpC2nMh)

- [Medium](https://stratos-network.medium.com/)

- [Twitter](https://twitter.com/stratos_network)

- [Github](https://github.com/stratosnet)

- [Whitepaper](https://www.thestratos.org/assets/pdf/stratoswhitepaper.pdf)

- [Wallet](https://www.thestratos.org/download.html)

## Hardware requirements
- OS : Ubuntu Linux 18.04 (LTS) x64 (Minimum Version)

- Read Access Memory : 16 GB (Recommended)

- CPU : 4 cores (higher better)

- Disk: 2 TB SSD Storage (Recommended)

- Bandwidth: 1 Gbps for Download / 100 Mbps for Upload


## Automatic Instalation:
```
wget -O stratos.sh https://raw.githubusercontent.com/DiscoverMyself/Stratos-Testnet/main/stratos.sh && chmod +x stratos.sh && ./stratos.sh
```

## Manual Instalation
Stratos [Official Docs](https://github.com/stratosnet/sds/wiki/Tropos-Incentive-Testnet)

## Set Custom Port (OPTIONAL)
**if you meet issues when running your node, try to change your port**
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:14658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:14657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:14060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:14656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \"14660\"%" $HOME/.stchaind/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1417\"%; s%^address = \":8080\"%address = \":1480\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:1490\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:1491\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:1445\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:1446\"%" $HOME/.stchaind/config/app.toml
```

## Wallet Configuration
**Add new wallet**
```
stchaind keys add $WALLET
```

**Request Faucet**
```
curl --header "Content-Type: application/json" --request POST --data '{"denom":"stos","address":"$(stchaind keys show wallet -a)"} ' https://faucet-tropos.thestratos.org/credit
```
NB: if you found error with `Address is not in the expected format for this chain.` you need to change `$(stchaind keys show wallet -a)` with your stratos address `st...`

**Recover wallet**
```
stchaind keys add $WALLET --recover
```

**Wallet list**
```
stchaind keys list
```

**Check Balance**
```
stchaind query bank balances $(stchaind keys show wallet -a)
```

**Delete Wallet**
```
stchaind keys delete $WALLET
```


## Validator Configuration
**Create Validator**
```
stchaind tx staking create-validator \
--amount=1stos \
--pubkey=$(stchaind tendermint show-validator) \
--moniker=$NODENAME \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=$WALLET \
--chain-id=tropos-5 --gas-prices=1000000000wei -y
```

**Check Validator address**

```
stchaind keys show wallet --bech val -a
```

**Edit Validator**

```
stchaind tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=tropos-5 --gas-prices=1000000000wei \
  --from=$WALLET
```
 
**Delegate to Validator**
```
stchaind tx staking delegate $(stchaind keys show wallet --bech val -a) 1000000ustos --from $WALLET --chain-id $STRATOS_CHAIN_ID --gas-prices 1000000000wei
```

**Unjail Validator**
```
stchaind tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$STRATOS_CHAIN_ID \
  --gas=auto --gas-adjustment 1.5
```
  
**Useful Commands**
1. Synchronization info

`
stchaind status 2>&1 | jq .SyncInfo
`

2. Validator Info

`
stchaind status 2>&1 | jq .ValidatorInfo
`

3. Node Info

`
stchaind status 2>&1 | jq .NodeInfo
`

4. Show Node ID

`
stchaind tendermint show-node-id
`

5. Delete Node

```
systemctl stop stchaind
systemctl disable stchaind
rm -rvf .stchaind
rm -rvf stratos.sh
rm -rvf stchaind
```

