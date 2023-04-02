#!/bin/bash

assets=/workspace/code/Week02/assets
keypath=/workspace/keys
from="$1"
txin="$2"
to="$3"
body="$assets/send-ada.txbody"
tx="$assets/send-ada.tx"

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "$txin" \
    --tx-out "$(cat "$keypath/$to.addr") + 3000000 lovelace" \
    --tx-out-inline-datum-file "$assets/unit.json" \
    --change-address "$(cat "$keypath/$from.addr")" \
    --out-file "$body"
    
# Sign the transaction
cardano-cli transaction sign \
    --tx-body-file "$body" \
    --signing-key-file "$keypath/$from.skey" \
    --testnet-magic 2 \
    --out-file "$tx"

# Submit the transaction
cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file "$tx"

tid=$(cardano-cli transaction txid --tx-file "$tx")
echo "transaction id: $tid"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"