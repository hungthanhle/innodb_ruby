```
https://github.com/datacharmer/test_db
db_sample/
mkdir Downloads/db_sample/
git clone https://github.com/datacharmer/test_db.git
cd test_db/

mysql < employees.sql
```

Bỏ
```
git clone https://github.com/hungthanhle/simple_devise_token_auth.git

bundle install
rails db:create
rails db:migrate

<!-- SQL -->
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `provider` varchar(255) NOT NULL DEFAULT 'email',
  `uid` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime(6) DEFAULT NULL,
  `allow_password_change` tinyint(1) DEFAULT '0',
  `remember_created_at` datetime(6) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime(6) DEFAULT NULL,
  `confirmation_sent_at` datetime(6) DEFAULT NULL,
  `unconfirmed_email` varchar(255) DEFAULT NULL,
  `tokens` text,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `employee_uid` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `discarded_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email_and_discarded_at_and_company_id_and_uid` (`email`,`discarded_at`,`company_id`,`uid`),
  UNIQUE KEY `index_users_on_employee_uid` (`employee_uid`),
  UNIQUE KEY `index_users_on_phone_and_discarded_at_and_company_id_and_uid` (`phone`,`discarded_at`,`company_id`,`uid`),
  UNIQUE KEY `index_users_on_uid_and_provider_and_discarded_at` (`uid`,`provider`,`discarded_at`),
  KEY `index_users_on_confirmation_token` (`confirmation_token`),
  KEY `index_users_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```
  
