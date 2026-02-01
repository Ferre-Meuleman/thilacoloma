#!/bin/bash

# Fix nginx configuration to allow Statamic CP assets

cat > /tmp/thilacoloma-nginx.conf << 'EOF'
server {
    listen 80;
    listen [::]:80;
    
    server_name _;
    root /var/www/thilacoloma/public;
    index index.php index.html;
    
    # Security headers (not for CP - too restrictive for Vue.js)
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;
    
    # Handle PHP files
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    # PHP-FPM configuration
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_hide_header X-Powered-By;
    }
    
    # Allow access to Statamic CP assets (must come before vendor deny)
    location ~ ^/vendor/statamic/cp/ {
        try_files $uri $uri/ =404;
    }
    
    # Allow access to Statamic Logbook assets
    location ~ ^/vendor/statamic-logbook/ {
        try_files $uri $uri/ =404;
    }
    
    # Deny access to sensitive files
    location ~ /\.(?!well-known).* {
        deny all;
    }
    
    # Deny access to specific directories (but not vendor/statamic/cp - handled above)
    location ~ ^/(storage|bootstrap|config|database|resources|routes|tests|vendor)/ {
        deny all;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|gif|png|css|js|ico|svg)$ {
        expires 1M;
        add_header Cache-Control "public, immutable";
    }
    
    # Security.txt
    location = /.well-known/security.txt {
        return 301 $scheme://$server_name/security.txt;
    }
}
EOF

# Move to nginx config and test
sudo mv /tmp/thilacoloma-nginx.conf /etc/nginx/sites-enabled/thilacoloma

# Test nginx configuration
if sudo nginx -t; then
    echo "✓ Nginx configuration valid"
    sudo systemctl reload nginx
    echo "✓ Nginx reloaded"
else
    echo "✗ Nginx configuration invalid - rolling back"
    exit 1
fi
