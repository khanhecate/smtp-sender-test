#!/bin/bash
#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx

# Install PHP and PHP-FPM with common extensions
echo "Installing PHP and necessary extensions..."
sudo apt install -y php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip

# Start and enable Nginx service
echo "Starting and enabling Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure Nginx to use PHP
echo "Configuring Nginx to work with PHP..."
NGINX_CONF="/etc/nginx/sites-available/default"

sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Test Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Reload Nginx to apply the changes
echo "Reloading Nginx..."
sudo systemctl reload nginx

# Set up a test PHP file
echo "Setting up a test PHP file..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Print completion message
echo "Installation complete. You can verify the PHP installation by visiting http://your_server_ip/info.php"
