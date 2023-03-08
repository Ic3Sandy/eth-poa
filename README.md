# Deploy Blockchain POA (Validator)

> networkid 224

## Install docker and docker compose

```bash
curl https://get.docker.com | sh
```

## 1. set password to password.txt file

```bash
head -1 /dev/urandom | base64 | md5sum
```

## 2. create new account

```bash
cd validator
```

```bash
docker run --rm -it -v $PWD:/validator -w /validator ethereum/client-go:v1.11.3 --datadir /validator/node --password password.txt account new
```

## 3. init-genesis Validator

```bash
docker run --rm -it -v $PWD:/validator -w /validator ethereum/client-go:v1.11.3 --datadir /validator/node --nousb init genesis.json
```

## 4. deploy

```bash
docker compose up -d validator
docker compose logs -f validator
```

## 5. JavaScript Console

> <https://geth.ethereum.org/docs/rpc/server>

```bash
docker compose exec validator sh
geth --datadir /validator/node attach
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
docker compose exec validator geth --datadir /validator/node attach --exec 'admin.nodeInfo'
```

command-line for add validator

```bash
docker compose exec validator geth --datadir /validator/node attach --exec 'clique.propose("0x048F519b032bAfa19Cf28D0cbf717a5fd119fA7A", true)'
```

command-line for check validator

```bash
docker compose exec validator geth --datadir /validator/node attach --exec 'clique.getSigners()'
```

## If you want to reset the data in order to perform a new join

## 7. Removedb

```bash
docker run --rm -it -v $PWD:/validator -w /validator ethereum/client-go:v1.11.3 --datadir /validator/node --nousb removedb
```

And please re-initiate the genesis before deploying again.

```bash
docker run --rm -it -v $PWD:/validator -w /validator ethereum/client-go:v1.11.3 --datadir /validator/node --nousb init genesis.json
```

## Start RPC

## 1. Check genesis.json file is correct and init genesis

```bash
cd rpc
```

```bash
docker run --rm -it -v $PWD:/rpc -w /rpc ethereum/client-go:v1.11.3 --datadir /rpc/node --nousb init genesis.json
```

## 2. Add bootnode in docker-compose by get from enode of validator

```bash
--bootnodes ""
```

## 3. deploy

```bash
docker compose up -d
docker compose logs -f
```