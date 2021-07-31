Quick and Dirty Alonzo White Bash Scripts
=========================================

These are my helper scripts while working with the Alonzo White testnet.

I use this repo in some of [my notes](https://plutus-pioneer-program.readthedocs.io/en/latest/alonzowhiteex1.html) on running the Alonzo White exercises.

Below is the old README which is a little out-of-date and I'll remove it once I've finished the above notes.

Setup
-----

Put all .addr files in ./wallets and all Plutus scripts in ./scripts. Put all .skey and .vkey files in ~/wallets.

Set environment variables

    export CARDANO_CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli
    export TESTNET_MAGIC_NUM=7

Functions file
--------------

The various scripts use the functions.sh file. One of the functions in that file is called *getInputTx* and
which will prompt the user for a wallet name and then ask them to select a UTxO. Various environment variables are then set
which can be used in writing scripts.

    SELECTED_UTXO (Hash#Index)
    SELECTED_WALLET_ADDR
    SELECTED_UTXO_LOVELACE
    SELECTED_WALLET_NAME

Some Helpers
------------

Gets the UTxOs sitting at the address of the ./scripts/AlwaysSucceeds.plutus script.

	./contractBalance.sh AlwaysSucceeds

Gets the balance of the address in ~/wallets/mywallet.addr

	./balance.sh mywallet

Pay to smart contract. This will prompt for a wallet and transaction. Arguments are payment, fee, script name and datum.

	./payToScript.sh 1010011010 200000 AlwaysSucceeds 6666

Get from smart contract. This will prompt for a script UTxO and a collateral UTxO. Arguments are the same as for payToScript.sh.

	./getFromScript.sh 10000000 110174521 AlwaysSucceeds 6666

