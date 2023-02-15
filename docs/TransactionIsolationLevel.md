# Transaction isolation level

* A database transation must satisfy the ACID property

## ACID


| ACID        | Description                                                                                       |
|-------------|---------------------------------------------------------------------------------------------------|
| ATOMICITY   | Either all operations complete succesfully or <br/> the transaction fails and the db is unchanged |
| CONSISTENCY | The DB state must be valid after the transaction. All constraints must be satisfied               |
| ISOLATION   | Concurrent transactions must not affect each other                                                |                                                |
| DURABILITY  | Data written by a successful transaction must be recorded in persistent storage                   |                                                |


## Read Phenomena

Occurs when there is interference with transactions. If a DB is running at a low level
of transaction isolation
- Dirty Read
- Non-repeatable read
- Phantom Read
- Serialization Anomaly

### Dirty Read
A transaction reads data written by other concurrent uncommitted transaction

### Non-repeatable Read
A transaction reads the same row twice and sees different value because it has 
been modified by other committed transaction

### Phantom Read
A transaction re-executes a query to find rows that satisfy a condition 
and sees a different set of rows due to changes by other committed transaction

### Serialization anomaly
The result of a group of concurrent committed transactions is impossible to achieve
if we try to run them sequentially in any order without overlapping

## How to deal with this phenomena?

The ANSI (American National Standards Institute) defined:

### 4 Standard isolation levels
| name             | level     | desc                                                                                           |
|------------------|-----------|------------------------------------------------------------------------------------------------|
| Read Uncommitted | low       | Can see data written by uncommited transaction. Allows dirty read to happen                    |
| Read Commited    | med-low   | Only see data written by committed transaction. Dirty read does not happen                     |
| Repeatable Read  | med- high | Same read query always returns same result                                                     |
| Serializable     | high      | Can achieve same result if execute transactions serially in some order instead of concurrently |




