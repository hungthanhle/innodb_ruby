```
docker start abb588943a46

docker exec -it abb588943a46 bash

service mysql start

innodb_space -s /var/lib/mysql/ibdata1 system-spaces
innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees space-indexes
innodb_space -s /var/lib/mysql/ibdata1 -T employees/employees -I PRIMARY index-recurse

FSP_HDR & XDES:
innodb_space -f /var/lib/mysql/test/t.ibd -p 0 page-dump | head -n 200
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 0 page-dump | grep "#<Innodb::Xdes:0x"
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 0 page-dump | grep "#<Innodb::Xdes:0x" | wc -l

INODE:
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 2 page-dump | head -n 200

INDEX:
innodb_space -f /var/lib/mysql/test/t.ibd -p 3 page-dump
innodb_space -f /var/lib/mysql/employees/departments.ibd -p 3 page-dump | head -n 200

list space:
một số lệnh để thấy space:
    innodb_space -f /var/lib/mysql/ibdata1 space-page-type-regions
    innodb_space -f /var/lib/mysql/test/t.ibd space-page-type-regions
```
  
