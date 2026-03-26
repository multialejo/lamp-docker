FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Install LAMP packages
RUN apt update && \
    apt install -y apache2 mariadb-server php libapache2-mod-php php-mysql && \
    apt clean

# Create PHP test page
RUN echo "<?php \
echo '<h1>Servidor Apache con Mysql y PHP (LAMP)</h1>'; \
phpinfo(); \
?>" > /var/www/html/index.php

# Expose Apache port
EXPOSE 80

# Start services
CMD service mariadb start && apachectl -D FOREGROUND
