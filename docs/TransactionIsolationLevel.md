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


## Get current transaction isolation level

### MySQL

Get Isolation Level
```sql
-- Get current session isolation level
SELECT @@transaction_isolation;

-- Get current global isolation level
SELECT @@global.transaction_isolation;
```

Change Isolation level in mysql
```sql
set session transaction isolation level read uncommited;
```

## Showing the read phenomena

### Using Read Uncommitted isolation level - Dirty Read
![readp_1_read_uncommitted_show_dirty_read_explained.png](img%2Freadp_1_read_uncommitted_show_dirty_read_explained.png)


### Using Read Committed isolation level - Dirty Read
![readp_2_read_committed_show_dirty_read_prevented_explained.png](img%2Freadp_2_read_committed_show_dirty_read_prevented_explained.png)

### Using Read Committed isolation level - No repeatable read
![readp_3_read_committed_show_non_repeatable_read_explained.png](img%2Freadp_3_read_committed_show_non_repeatable_read_explained.png)

### Using Read Committed isolation level - Phantom read
![readp_4_read_committed_show_phantom_read_explained.png](img%2Freadp_4_read_committed_show_phantom_read_explained.png)

### Using Repeatable Read isolation level - Repeatable and Phantom prevented
![readp_5_repeatable_read_show_phantom_and_no_repeatable_read_prevented_explained.png](img%2Freadp_5_repeatable_read_show_phantom_and_no_repeatable_read_prevented_explained.png)

### Postgres Using Repeatable Read isolation level - Repeatable and Phantom prevented
![readp_6_pg_repeatable_read_show_phantom_and_no_repeatable_read_prevented_explained.png](img%2Freadp_6_pg_repeatable_read_show_phantom_and_no_repeatable_read_prevented_explained.png)


### Understanding a serialization anomaly
In the image below the second record should be 540 = 270 + 270
![readp_7_understanding_serialization_issue_explained.png](img%2Freadp_7_understanding_serialization_issue_explained.png)


### Using serializable level
In the image below the sum is not allowed but postgres gives us a HINT: 
**The transaction might succeed if retried**
![readp_8_using_serializable_steps.png](img%2Freadp_8_using_serializable_steps.png)


## Summary

Keep in mind:
- **Implement Retry Mechanism**: There might be erros, timeout or deadlock.
- **Read documentation**: Each DB engine might implment isolation level differently


### PostGres
![readp_9_pg_summary.png](img%2Freadp_9_pg_summary.png)

### MySQL
![readp_9_mysql_summary.png](img%2Freadp_9_mysql_summary.png)


### Comparison
![readp_9_pg_comp_1.png](img%2Freadp_9_pg_comp_1.png)