rm-node:
	rm -rf validator/node && rm -rf rpc/node

new-acc:
	head -1 /dev/urandom | base64 | md5sum | head -c 32 > validator/password.txt && \
	docker run --rm -it -v $(PWD)/validator:/validator -w /validator \
	ethereum/client-go:v1.11.3 --datadir /validator/node --password password.txt account new \
	| grep -oE '0x[[:xdigit:]]{40}' | sed 's/0x//'

init-genesis-validator:
	cp validator/genesis.json rpc/genesis.json && \
	docker run --rm -it -v $(PWD)/validator:/validator -w /validator \
	ethereum/client-go:v1.11.3 --datadir /validator/node --nousb init genesis.json

start-validator:
	docker compose -f validator/docker-compose.yml up -d && \
	docker compose -f validator/docker-compose.yml logs -f

init-genesis-rpc:
	docker run --rm -it -v $(PWD)/rpc:/rpc -w /rpc \
	ethereum/client-go:v1.11.3 --datadir /rpc/node --nousb init genesis.json
	

get-enode-validator:
	docker compose -f validator/docker-compose.yml exec validator \
	geth --datadir /validator/node attach --exec 'admin.nodeInfo'

start-rpc:
	docker compose -f rpc/docker-compose.yml up -d && \
	docker compose -f rpc/docker-compose.yml logs -f

build-blockscout:
	docker compose -f blockscout/docker-compose/docker-compose.yml build

start-blockscout:
	docker compose -f blockscout/docker-compose/docker-compose.yml up -d db && \
	sleep 10 && \
	docker compose -f blockscout/docker-compose/docker-compose.yml up -d blockscout && \
	docker compose -f blockscout/docker-compose/docker-compose.yml logs -f blockscout

down-blockscout:
	docker compose -f blockscout/docker-compose/docker-compose.yml down -v

down-validator:
	docker compose -f validator/docker-compose.yml down -v

down-rpc:
	docker compose -f rpc/docker-compose.yml down -v
