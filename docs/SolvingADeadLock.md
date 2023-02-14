# Solving a DB Deadlock

See commit: 

https://github.com/luislard/simplebank/tree/85008be66345ef4310050fa60009d563a9edb50c

Ok, so we have a deadlock, how to check the DB and fix it?

```
// order of the events of 2 concurrent transactions. 
// tx1 => transaction1, tx2 => transation2

tx 2 create transfer
tx 2 create entry 1

tx 1 create transfer

tx 2 create entry 2
tx 2 get account 1

tx 1 create entry 1
tx 1 create entry 2
tx 1 get account 1
tx 1 update account 1
// deadlock
```

First, understand your current sequence of theoretical queries:

```SQL
BEGIN;
    INSERT INTO transfers (from_account_id, to_account_id, amount) VALUES (1, 2, 10) RETURNING *;
    
    INSERT INTO entries (account_id, amount) VALUES (1, -10) RETURNING *;
    INSERT INTO entries (account_id, amount) VALUES (2, 10) RETURNING *;

    SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
    UPDATE accouts SET balance = 90 WHERE id = 1 RETURNING *;

    SELECT * FROM accounts WHERE id = 2 FOR UPDATE;
    UPDATE accouts SET balance = 110 WHERE id = 2 RETURNING *;

ROLLBACK;
```

When running the queries we got in the sequence we got an error:
![debugging_deadlock_error.png](img%2Fdebugging_deadlock_error.png)

Lets replicate all again and stop as soon we detect a lock:
![debug_lock_1.png](img%2Fdebug_lock_1.png)

Lets debug the locks. Take the following query:
```SQL
-- See: https://wiki.postgresql.org/wiki/Lock_Monitoring
SELECT blocked_locks.pid     AS blocked_pid,
         blocked_activity.usename  AS blocked_user,
         blocking_locks.pid     AS blocking_pid,
         blocking_activity.usename AS blocking_user,
         blocked_activity.query    AS blocked_statement,
         blocking_activity.query   AS current_statement_in_blocking_process
   FROM  pg_catalog.pg_locks         blocked_locks
    JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
    JOIN pg_catalog.pg_locks         blocking_locks 
        ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid

    JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
   WHERE NOT blocked_locks.granted;
```

Here we see the INSERT query is blocking the SELECT query.
![debug_lock_locked_queries_SQL_result.png](img%2Fdebug_lock_locked_queries_SQL_result.png)


Let's use another query from the same wiki page, we added `a.application_name` and 
`l.locktype``:
```sql
SELECT a.datname,
       a.application_name,
         l.relation::regclass,
         l.transactionid,
         l.mode,
         l.locktype,
         l.GRANTED,
         a.usename,
         a.query,
         a.pid
FROM pg_stat_activity a
JOIN pg_locks l ON l.pid = a.pid
ORDER BY a.query_start;
```

We see that there is only 1 lock that has not been granted, it comes from the SELECT FROM `accounts` query of process 527.
It is not granted because it is trying to acquire a ShareLock of type transaction ID where the transaction ID is: 2251 
while this is being hold Exclusively by another process id 541 with the INSERT INTO `transfers` transfer query.


![debug_lock_logs.png](img%2Fdebug_lock_logs.png)

Question is: why a select to `accounts` is being blocked by an insert into `transfers`.


Let's check the schema creation:

```
...
ALTER TABLE "transfers" ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");
ALTER TABLE "transfers" ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");
...
```

So, there is a reference to accounts in the table transfers.

Explanation:

The problem is caused by two queries interacting with the ID 1 of accounts. 
Since there is a foreign key constraint: "Any update to the ID in the accounts table will affect the transfer table".
That's why when we select the account for update it needs to acquire a lock to prevent conflicts and ensure 
the consistency of the data
![debug_lock_explanation.png](img%2Fdebug_lock_explanation.png)


Hitting the deadlock:
![debug_lock_deadlock.png](img%2Fdebug_lock_deadlock.png)


### Solution

Inform Postgress that the UPDATE is not affecting the KEY by changing this:
```sql
-- name: GetAccountForUpdate :one
SELECT * FROM accounts
WHERE id = $1 LIMIT 1
FOR UPDATE;
```

To this:
```sql
-- name: GetAccountForUpdate :one
SELECT * FROM accounts
WHERE id = $1 LIMIT 1
FOR NO KEY UPDATE;
```