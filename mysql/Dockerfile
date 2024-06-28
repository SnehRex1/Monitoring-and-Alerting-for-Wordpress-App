# Start with the MySQL 8.0 image
FROM mysql:8.0

# Copy the custom MySQL configuration file
COPY my.cnf /etc/mysql/my.cnf

# Set environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress
ENV MYSQL_PASSWORD=wordpress_password
