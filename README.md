These are my helper scripts while working with the Alonzo White testnet.

Feel free to get in touch if you think there is something I might be able to help you with.

Put all .addr files and their associated .skey files in ~/wallets

Set the CARDANO_CLI to point to the correct version of cardano-cli.

	export CARDANO_CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli

Gets the UTxOs sitting at the address of the ~/scripts/AlwaysSucceeds.plutus script.

	./contractBalance.sh AlwaysSucceeds

Gets the balance of the address in ~/wallets/mywallet.addr

	./balance.sh mywallet

Pay to smart contract. This will prompt for a wallet and transaction. Arguments are payment, fee, script name and datum.

	./payToScript.sh 1010011010 200000 AlwaysSucceeds 666

Get from smart contract. This will prompt for a script UTxO and a collateral UTxO. Arguments are the same as for payToScript.sh.

	./getFromScript.sh 1010011010 200000 AlwaysSucceeds 666

