# Simple Bank App

This is my first go REST application


I do this because I want to learn Go.

# Notes:

During the course the following question arised:

### How will we talk to the db?
See: [DB_ORMs.md](docs%2FDB_ORMs.md)

**TL;DR:** We will use SQLC. It's a command that uses a pseudo language 
to create go code that speaks with the DB

## Postgres driver
See: github.com/lib/pq

## Testing helper
See https://github.com/stretchr/testify

## Reading env files and environment variables
We are using Viper https://github.com/spf13/viper

## API test mocks
We are using go mock https://github.com/golang/mock

## How to debug a deadlock in the database
See: [Solving A DeadLock.md](docs%2FSolvingADeadLock.md)

## Theory of Transaction Isolation Level
See: [TransactionIsolationLevel.md](docs%2FTransactionIsolationLevel.md)

## The list of validators
https://github.com/go-playground/validator#baked-in-validations 