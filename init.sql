-- init.sql
CREATE DATABASE
IF NOT EXISTS wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'%' IDENTIFIED BY 'wordpresspassword';
FLUSH PRIVILEGES;
