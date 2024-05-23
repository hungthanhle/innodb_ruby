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

cd Downloads/db_sample/
touch employees_db.rb
vi employees_db.rb
dùng file ở /examples/describer/employees_db.rb

innodb_space -f /var/lib/mysql/employees/dept_manager.ibd -r /home/Downloads/db_sample/employees_db.rb -d Employees_dept_manager_dept_no -p 3 index-recurse
innodb_space -f /var/lib/mysql/employees/dept_manager.ibd -r /home/Downloads/db_sample/employees_db.rb -d Employees_dept_manager_dept_no -p 4 index-recurse

innodb_space -s /var/lib/mysql/ibdata1 -T employees/dept_manager -I dept_no index-recurse

Index must be specified using a combination of either --space-file (-f) and --page (-p) or --system-space-file (-s), --table-name (-T), and --index-name (-I); see --help for usage information

innodb_space -f /var/lib/mysql/employees/dept_manager.ibd -r /home/Downloads/db_sample/employees_db.rb -d Employees_dept_manager_PRIMARY -p 4 index-recurse

innodb_space -f /var/lib/mysql/test/t.ibd -r /home/Downloads/db_sample/simple_describer.rb -d SimpleTDescriber -p 3 index-digraph
```
