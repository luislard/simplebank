createdb:
	docker-compose exec pg createdb --username=root --owner=root simple_bank
dropdb:
	docker-compose exec pg dropdb simple_bank
postgres:
	docker-compose up -d
migrateup:
	docker-compose run --rm migrate -path /migrations -database "postgres://root:secret@pg:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	docker-compose run --rm migrate -path /migrations -database "postgres://root:secret@pg:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	docker-compose run --rm migrate -path /migrations -database "postgres://root:secret@pg:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	docker-compose run --rm migrate -path /migrations -database "postgres://root:secret@pg:5432/simple_bank?sslmode=disable" -verbose down 1

init_migrate:
	docker-compose run --rm migrate create -ext sql -dir /migrations -seq init_schema

sqlc_init:
	docker-compose run --rm sqlc init

sqlc:
	docker-compose run --rm sqlc generate

test:
	go test -v -cover ./...

pgterm:
	docker-compose exec pg psql -U root -d simple_bank
server:
	go run ./main.go

mock:
	mockgen --destination db/mock/store.go --package mockdb --build_flags=--mod=mod github.com/luislard/simplebank/db/sqlc Store

.PHONY: createdb dropdb postgres init_migrate migrateup migratedown sqlc_init test pgterm server mock migratedown1 migrateup1