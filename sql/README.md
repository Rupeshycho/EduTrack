# SQL Files

This folder contains **plain SQL**, separate from Django's ORM, to demonstrate
direct database design and query-writing skills.

Two versions are provided depending on which database you use:

| Database   | Schema file             | Queries file                      |
|------------|--------------------------|------------------------------------|
| MySQL      | `schema.sql`              | `sample_queries.sql`               |
| PostgreSQL | `schema_postgresql.sql`   | `sample_queries_postgresql.sql`    |

They define the same 7 tables and the same 8 example queries — only the
syntax differs (e.g. `AUTO_INCREMENT` + `ENUM` in MySQL vs. `SERIAL` +
custom `CREATE TYPE ... AS ENUM` in PostgreSQL; `GROUP_CONCAT` vs
`STRING_AGG`; `CURDATE()` vs `CURRENT_DATE`). Both have been validated
against their respective SQL grammars.

- **schema*.sql** — hand-written `CREATE TABLE` statements that mirror
  the Django models in this project (users, students, teachers, classes,
  attendance, exams, results), with proper primary keys, foreign keys, and
  unique constraints.

- **sample_queries*.sql** — 8 real queries against that schema: multi-table
  joins, `GROUP BY` aggregates (attendance %, class averages), `HAVING`
  filters, and a string-aggregation example.

## How to use (PostgreSQL / pgAdmin)

1. Open pgAdmin, create a database called `edutrack_db`.
2. Open the Query Tool on that database and run `schema_postgresql.sql`.
3. Insert a few sample rows into `users`, `students`, `attendance`, `exams`,
   and `results`.
4. Run any query from `sample_queries_postgresql.sql` to see it in action.

## How to use (MySQL)

1. Install MySQL and open a client (MySQL Workbench, `mysql` CLI, phpMyAdmin, etc.)
2. Run `schema.sql` to create the database and tables.
3. Insert sample rows, then run queries from `sample_queries.sql`.

Note: when the Django app itself runs (see the main README), Django's ORM
generates equivalent SQL automatically against whichever `DATABASES` engine
is configured in `settings.py` (SQLite by default, with MySQL and PostgreSQL
options ready to uncomment). These `sql/` files are for demonstrating the
SQL layer explicitly, independent of the ORM.
