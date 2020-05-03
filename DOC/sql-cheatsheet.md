```sql
alter table table-name add column new-column varchar (20);   # add new column to table
alter table table-name drop column column-name;              # delete a column from table
create database database_name;                               # create database
DELETE from table-name where field-name = 'darth-vader';     # delete a row from a field
describe table-name;                                         # show database fields and field formats
drop database database_name;                                 # delete a database
drop table table_name;                                       # delete a table
grant all privileges on heaven_db.* to jesus@localhost;      # grant permissions to user
ls -lh /var/lib/mysql                                        # show databases size
mysql -h hostname -u root -p                                 # connect to mysql
mysqladmin -u root password YOURNEWPASSWORD                           # set root password
mysqladmin -u username -h your-mysql-host -p password 'newpassword'   # set user password
SELECT * FROM table-name WHERE field-name = "jesus";                  # show rows containing a value
SELECT * FROM table-name WHERE name = "Jesus" AND year = '1984';      # show records matching specified values
SELECT * FROM table-name WHERE rec RLIKE "^z";                        # search records using regex
SELECT * from table_name;                                             # show table data
SELECT col6,col5 FROM table-name ORDER BY col6 DESC;                  # show records and order
SELECT column_names FROM table-1, table-2 WHERE (table-1.column = table-2.column); # join tables
SELECT COUNT(*) FROM table-name;                                      # show how many rows in a table
SELECT DISTINCT column-name FROM table-name;                          # show unique records
show columns form table_name;                                         # show columns in a table
show databases;                                                       # list all databases
show tables;                                                          # show tables in current database
use database_name;                                                    # select a database
zcat database-backup.sql.gz | mysql -u root -p database-name          # import compressed database

```

**mysqldump:**

```bash
mysqldump -c -u username -p your-pass database-name table-name > /tmp/db-name.table-name.sql # dump a specific table
mysqldump -u root -p database-name > /tmp/database-backup.sql         # dump database
mysqldump -u root -p database-name | gzip -c | ssh me@host 'cat > /tmp/database-backup.sql.gz' # dump database to remote host with compression
mysqldump -u root -p database-name | gzip -v > database-backup.sql.gz # dump database with compression
mysqldump -u root -p your-root-password --opt >/tmp/databases.sql     # dump all databases (optimized)
mysqldump -u username -p your-database --ignore-table=your-database.broken-table > your-database.sql # dump and skip a single table
mysqldump --host=host1 --opt mydatabase | mysql --host=host2 -C newdatabase # tranfer database to another host
mysqldump --no-data --databases mydatabase1 mydatabase2 mydatabase3         # only dump database structure, not data
mysql -u username -p database-name < database-backup.sql                    # restore/import a database
```
