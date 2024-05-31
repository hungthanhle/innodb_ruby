```
cd readme/
docker build -t innodb_ruby .
docker run -dt -p 3307:3306 innodb_ruby
```
  
```
docker exec -it 0231eeb6db98 bash
~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 system-spaces

service mysql start
```
  
```
https://github.com/datacharmer/test_db
db_sample/
mkdir Downloads/db_sample/
git clone https://github.com/datacharmer/test_db.git
cd test_db/

mysql < employees.sql
```
  
### Lỗi  
```
~/.rbenv/shims/innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees -I PRIMARY index-recurse
```
lib/innodb/data_dictionary.rb:215:in `mtype_prtype_to_data_type'  
lib/innodb/data_dictionary.rb:177:in `mtype_prtype_to_type_string':  
undefined method `type' for nil:NilClass (NoMethodError)  
```
binding.irb
Ctrl + D
external_type = MYSQL_TYPE[internal_type].type  
```
Khi mysql_type = 10 thì internal_type = nil, đối chiếu tiếp mysql_type là Date là của trường birth_date  
  
Sửa thư viện:  
```
apt-get install vim

vi /root/.rbenv/versions/3.0.4/lib/ruby/gems/3.0.0/gems/innodb_ruby-0.12.0/lib/innodb/data_dictionary.rb

bỏ comment: DATE: MysqlType.new(value: 10,  type: :DATE),
```
  
```
innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees -I PRIMARY index-recurse
```
  
```
apt-get install build-essential libmysqlclient-dev

gem install mysql2

mysql -v
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('fill_password');
FLUSH PRIVILEGES;
CREATE DATABASE test;

irb
require "mysql2"
client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: '1234', database: 'test')
client.query("CREATE TABLE t (i INT UNSIGNED NOT NULL, PRIMARY KEY(i)) ENGINE=InnoDB")
=> mysql -v chuyển qua => mysql -u root -p

(1..1000000).to_a.shuffle.each_with_index do |i, index|
  client.query("INSERT INTO t (i) VALUES (#{i})")
  puts "Inserted #{index} rows..." if index % 10000 == 0
end

gem install gnuplot

innodb_space -s /var/lib/mysql/ibdata1 -T employees/dept_manager -I dept_no -p 4 index-recurse
innodb_space -s /var/lib/mysql/ibdata1 -T employees/dept_manager -I PRIMARY -p 3 index-recurse
```
```
cd /home/Downloads/db_sample/
touch employees_db.rb
vi employees_db.rb
dùng file ở /examples/describer/employees_db.rb

innodb_space -f /var/lib/mysql/employees/dept_manager.ibd -r /home/Downloads/db_sample/employees_db.rb -d Employees_dept_manager_dept_no -p 4 index-recurse
innodb_space -f /var/lib/mysql/employees/dept_manager.ibd -r /home/Downloads/db_sample/employees_db.rb -d Employees_dept_manager_PRIMARY -p 3 index-recurse



Index must be specified using a combination of either --space-file (-f) and --page (-p) or --system-space-file (-s), --table-name (-T), and --index-name (-I); see --help for usage information:
(-s and -T and -I):
innodb_space -s /var/lib/mysql/ibdata1 -T employees/dept_manager -I dept_no -p 4 index-recurse
(-f and -p):
innodb_space -f /var/lib/mysql/employees/dept_manager.ibd -r /home/Downloads/db_sample/employees_db.rb -d Employees_dept_manager_dept_no -p 4 index-recurse


innodb_space -f /var/lib/mysql/test/t.ibd -r /home/Downloads/db_sample/simple_describer.rb -d SimpleTDescriber -p 3 index-digraph
```

```
root@15946f90c5a6:/# cd Downloads/db_sample/
bash: cd: Downloads/db_sample/: No such file or directory
root@15946f90c5a6:/# cd /home/Downloads/db_sample/
root@15946f90c5a6:/home/Downloads/db_sample# git clone https://github.com/hungthanhle/employees_test_db.git
Cloning into 'employees_test_db'...
remote: Enumerating objects: 124, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 124 (delta 0), reused 1 (delta 0), pack-reused 120
Receiving objects: 100% (124/124), 74.28 MiB | 8.31 MiB/s, done.
Resolving deltas: 100% (62/62), done.
root@15946f90c5a6:/home/Downloads/db_sample# cd employees_test_db/
root@15946f90c5a6:/home/Downloads/db_sample/employees_test_db# mysql < employees.sql
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
root@15946f90c5a6:/home/Downloads/db_sample/employees_test_db# mysql < employees.sql -u root -p
Enter password: 
INFO
CREATING DATABASE STRUCTURE
INFO
storage engine: InnoDB
INFO
LOADING departments
INFO
LOADING employees
INFO

root@15946f90c5a6:/home/Downloads/db_sample/employees_test_db# mysql -u root -p     
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 15
Server version: 10.3.39-MariaDB-0ubuntu0.20.04.2 Ubuntu 20.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> select * from other_db.employees limit 1;
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
|  10001 | 1953-09-02 | Georgi     | Facello   | M      | 1986-06-26 |
+--------+------------+------------+-----------+--------+------------+
1 row in set (0.000 sec)
```
