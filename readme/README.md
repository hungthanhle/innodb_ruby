```
~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 system-spaces
~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees space-indexes
~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees -I PRIMARY index-recurse
```
  
```
https://github.com/datacharmer/test_db
db_sample/
mkdir Downloads/db_sample/
git clone https://github.com/datacharmer/test_db.git
cd test_db/

mysql < employees.sql
```
  
