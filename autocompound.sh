#!/bin/bash

GREEN_COLOR="\033[0;32m"
RED_COLOR="\033[0;31m"
WITHOUT_COLOR="\033[0m"

echo -n Password:
read -s password
echo

KEY_NAME=$(echo $password | stchaind keys list --output json| jq -r ".[] .name")
DELEGATOR_ADDRESS=$(echo $password | stchaind keys show ${KEY_NAME} --output json | jq -r '.address')
VALIDATOR_ADDRESS=$(echo $password | stchaind keys show ${KEY_NAME} -a --bech val)
ONE_STOS="1000000000000000000"
DELAY=180 #in secs - how often restart the script
NODE=$(stchaind status | jq -r .NodeInfo.other.rpc_address)

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo -e "${password}\ny\n" | stchaind tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --commission --gas="1000000" --gas-adjustment="1.15" --gas-prices="30000000000wei" --chain-id tropos-5 --from ${KEY_NAME} --node ${NODE} --yes | grep "raw_log\|txhash"
for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
BALANCE=$(stchaind query bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount')
echo -e "BALANCE: ${GREEN_COLOR}${BALANCE}${WITHOUT_COLOR} wei\n"
        echo -e "Claim rewards\n"
        echo -e "${password}\n${password}\n" | stchaind tx distribution withdraw-all-rewards --gas="1000000" --gas-adjustment="1.15" --gas-prices="30000000000wei" --chain-id tropos-5 --from ${KEY_NAME} --node ${NODE} --yes | grep "raw_log\|txhash"
for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
BALANCE=$(stchaind query bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount');
        TX_AMOUNT=$(bc <<< "$BALANCE - $ONE_STOS" )
echo -e "BALANCE: ${GREEN_COLOR}${BALANCE}${WITHOUT_COLOR} wei\n"
        echo -e "Stake ALL\n"
if awk "BEGIN {return_code=($BALANCE > $ONE_STOS) ? 0 : 1; exit} END {exit return_code}";then
            echo -e "${password}\n${password}\n" | stchaind tx staking delegate ${VALIDATOR_ADDRESS} ${TX_AMOUNT}wei --gas="1000000" --gas-prices="30000000000wei" --gas-adjustment="1.15" --chain-id=tropos-5 --from ${KEY_NAME} --node ${NODE}  --yes | grep "raw_log\|txhash"
        else
                                echo -e "BALANCE: ${GREEN_COLOR}${BALANCE}${WITHOUT_COLOR} wei is lower than $ONE_STOS wei\n"
        fi
for (( timer=${DELAY}; timer>0; timer-- ))
        do
            printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
            sleep 1
        done
done
