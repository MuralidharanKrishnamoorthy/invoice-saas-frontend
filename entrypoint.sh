#!/bin/sh
set -e

# Substitute PORT in the template
echo "Substituting PORT=${PORT:-80} in nginx configuration..."
envsubst '${PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

echo "Generated nginx configuration:"
cat /etc/nginx/conf.d/default.conf

echo "Listing files in /usr/share/nginx/html:"
ls -R /usr/share/nginx/html

# Start Nginx
echo "Starting Nginx..."
exec nginx -g "daemon off;"
