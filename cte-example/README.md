# CTE - Common Table Expression

Real example using CTE to decrease the runtime of a query drastically. Most of the structure was preserved to respect TOTVS' ERP (Enterprise Resource Planning) project format.

The whole example will be emulated using **PostgreSQL**, my preferred database. But the real case was solved under **MySQL Server**. Considering that CTE is supported on most of the databases, you decide which flavor you want to choose.

## Prerequisites

There are some prerequisites do execute the full automation of this example.

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

All steps covered here can be applied to your project to increase your productivity.

## Time to run!

To reproduce this example, `clone` the project and type `vagrant up` over the terminal.

```
$ clone cte-example
$ cd cte-example
$ vagrant up
```

## Time to play!

To avoid accessing the machine (`vagrant ssh`) and then reaching the database, type the command below to get straight to the database. WARN: this is only possible due to `pg_hba.conf` modification to allow any connection. This configuration is **insecure**, but it is acceptable for development purposes.

```
$ vagrant ssh -c "psql -U postgres"
```

## CTE Docs

- [PostgreSQL](https://www.postgresql.org/docs/9.1/static/queries-with.html) (the foundation for this example)
- [SQL Server](https://dev.mysql.com/doc/refman/8.0/en/with.html)
- ... (***TODO** other supported databases*)
