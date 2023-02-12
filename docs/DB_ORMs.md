# How will we talk to the db?

### DATABASE/SQL
Pros:
- Fast and straight forward

Cons:
- Manual mapping SQL fields to variables
- Easy to make mistakes, not caught until runtime

### GORM
Pros:
- CRUD functions already implemented, very short production code

Cons:
- Must learn to write queries using gorm's funtions
- Run slowly on high load

### SQLX
Pros:
- quite fast & easy to use
- Fields mapping via query text & struct tags
- Failure won't occur until runtime

### SQLC
Website: https://sqlc.dev/

Pros:
- quite fast & easy to use
- automatic code generation
- catch SQL query errors before generating codes

Cons:
- Full support Postgres. MySQL is experimental