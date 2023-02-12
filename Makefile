createdb:
	docker-compose exec pg createdb --username=root --owner=root simple_bank
dropdb:
	docker-compose exec pg dropdb simple_bank
postgres:
	docker-compose up -d
migrateup:
	docker-compose run --rm migrate -path /migrations -database "postgres://root:secret@pg:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	docker-compose run --rm migrate -path /migrations -database "postgres://root:secret@pg:5432/simple_bank?sslmode=disable" -verbose down

init_migrate:
	docker-compose run --rm migrate create -ext sql -dir /migrations -seq init_schema

.PHONY: createdb dropdb postgres init_migrate migrateup migratedown