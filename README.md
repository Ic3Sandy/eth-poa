# Blockchain POA

> networkid 224

## Install docker and docker compose

```bash
curl https://get.docker.com | sh
```

## 1. create new account

Use address from output to replace in genesis.json in extradata

```bash
make new-acc
```

## 2. init-genesis Validator

Check genesis.json file is correct and init genesis

```bash
make init-genesis-validator
```

## 3. Start Validator

```bash
make start-validator
```

## JavaScript Console

> <https://geth.ethereum.org/docs/rpc/server>

```bash
make attach-validator
```

|                   | Command                                                                |
| ----------------- | ---------------------------------------------------------------------- |
| Get Signer        | > clique.getSigners()                                                  |
| Check Peers Count | > net.peerCount                                                        |
| Check IP Peers    | > admin.peers                                                          |
| Add Peers Static  | > admin.addPeer("enode://a979fb575495b8d6db44f75@52.16.188.185:30303") |
| Check NodeInfo    | > admin.nodeInfo                                                       |
| Add Singer        | > clique.propose("0xd881234E73223d1623E0d56789942eA1c0B67890", true)   |
| Remove Signer     | > clique.propose("0xd881234E73223d1623E0d56789942eA1c0B67890", false)  |
| Check Vote        | > clique.proposals                                                     |
| Check Vote        | > clique.status()                                                      |

command-line for get enode

```bash
docker compose -f validator/docker-compose.yml exec validator geth --datadir /validator/node attach --exec 'admin.nodeInfo'
```

command-line for add validator

```bash
docker compose -f validator/docker-compose.yml exec validator geth --datadir /validator/node attach --exec 'clique.propose("0x048F519b032bAfa19Cf28D0cbf717a5fd119fA7A", true)'
```

command-line for check validator

```bash
docker compose -f validator/docker-compose.yml exec validator geth --datadir /validator/node attach --exec 'clique.getSigners()'
```

## If you want to reset the data in order to perform a new join

## Removedb

```bash
make removedb-validator
```

And please re-initiate the genesis before deploying again.

```bash
make init-genesis-validator
```

## Start RPC

## 1. Check genesis.json file is correct and init genesis

```bash
make init-genesis-rpc
```

## 2. Add bootnode in docker-compose by get from enode of validator

```bash
make get-enode-validator

# and

--bootnodes ""
```

## 3. Start RPC

```bash
make start-rpc
```

## Blockscout

Use version `v4.1.8-beta`

```bash
wget https://github.com/blockscout/blockscout/archive/refs/tags/v4.1.8-beta.zip
```

If you want to change logo or theme

```bash
cp logo.png blockscout/apps/block_scout_web/assets/static/images/.
```

```scss
# apps/block_scout_web/assets/css/theme/_variables.scss
@import "base_variables";
// @import "neutral_variables";
@import "poa_variables";
```

## 1. Update env file

```bash
# docker-compose/envs/common-blockscout.env

NETWORK=NEXT
SUBNETWORK=Testnet
SECRET_KEY_BASE=56NtB48ear7+wMSf0IQuWDAAazhpb31qyc7GiyspBP2vh7t5zlCsF5QDv76chXeN # for testing only
BLOCK_TRANSFORMER=clique
```

## 2. Update .po file

```bash
# apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po
msgid "Ether"
msgstr "NEXT"

msgid "ETH"
msgstr "NEXT"
```

## 3. Build docker

```bash
make build-blockscout
```

## 4. Start Blockscout

```bash
make start-blockscout
```

### Down Services

- Validator

```bash
make down-validator
```

- RPC

```bash
make down-rpc
```

- Blockscout

```bash
make down-blockscout
```

- All

```bash
make down-all
```
