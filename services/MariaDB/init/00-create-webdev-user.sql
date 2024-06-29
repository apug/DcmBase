-- Create webdev user with full access from any host
CREATE USER IF NOT EXISTS 'webdev'@'%' IDENTIFIED BY 'webdev';
GRANT ALL PRIVILEGES ON *.* TO 'webdev'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
