/**
 * MySQL server init.
 *
 * SQL queries in this file will be executed the first time the MySQL server is started.
 */
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE DATABASE IF NOT EXISTS civiccrm;
GRANT ALL PRIVILEGES ON *.* TO 'wordpress'@'%' IDENTIFIED BY 'wordpress';
