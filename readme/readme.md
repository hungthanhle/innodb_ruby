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
