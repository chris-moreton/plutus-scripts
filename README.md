These are my helper scripts while working with the Alonzo White testnet.

They are probably broken but you may find something useful here if you know what you are looking for.

Feel free to get in touch if you think there is something I might be able to help you with.

Put all .addr files and their associated .skey files in ~/wallets

Clues to the order of the arguments to each script can be found in the scripts themselves.

Set the CARDANO_CLI to point to the correct version of cardano-cli.

	export CARDANO_CLI=/data/white/cardano-node/result/alonzo-white/cardano-cli/bin/cardano-cli

Ask for a wallet and UTxO row. Useful for various automations.

	./txBalance.sh
	Wallet Name: wallet
	                           TxHash                                 TxIx        Amount
	--------------------------------------------------------------------------------------
	8c5f24a4eee17773d2ddef2ee1493248b1c45c56e6851d6f330deee1dc23a21f     1        97657486811 lovelace + TxOutDatumHashNone
	a9a966bf7112d0a66c63c73cb5e84a5e03a9bb1a354a75b99f1ba0008655991e     0        99832959 lovelace + TxOutDatumHashNone
	da8679a83da9a8f4a71a303d60e328290c8cc61ceac103bc54ce022bd6e05baa     0        189899800000 lovelace + TxOutDatumHashNone
	f6b2ec8bb74b388b5864f73029b35e26f5feb5c2cd570694a4b2638d28507386     0        1000000 lovelace + TxOutDatumHashNone
	TX Row Number: 2
	ADA held in a9a966bf7112d0a66c63c73cb5e84a5e03a9bb1a354a75b99f1ba0008655991e#0 is 99832959

Gets the UTxOs sitting at the address of the ~/scripts/AlwaysSucceeds.plutus script.

	./contract_balance.sh AlwaysSucceeds

Gets the balance of the address in ~/wallets/mywallet.addr

	./balance.sh mywallet

Pay to smart contract.

	./pay_to_script.sh d811ec87ac24c4c9dbd6db5c949e8585c854ed255cd422394adfadf184e441a8 1 98667665302 1010011010 167481 666 AlwaysSucceeds.plutus

Get from smart contract.

	./get_from_script.sh d811ec87ac24c4c9dbd6db5c949e8585c854ed255cd422394adfadf184e441a8 0 666000000 1000000 110174477 666 8c5f24a4eee17773d2ddef2ee1493248b1c45c56e6851d6f330deee1dc23a21f 1 AlwaysSucceeds mywallet

Pay from payment.addr to wallet.addr.

	./pay.sh 6a72a56ae78aa1ff11f4149dd19df1161de30514222dce4bd0b7a2505f04d8ac 1 889900000000 189900000000 200000 payment wallet

