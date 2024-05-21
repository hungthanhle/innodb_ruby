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
