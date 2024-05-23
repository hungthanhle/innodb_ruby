```
docker start abb588943a46

docker exec -it abb588943a46 bash

service mysql start

innodb_space -s /var/lib/mysql/ibdata1 system-spaces
innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees space-indexes
innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees -I PRIMARY index-recurse
```
  
