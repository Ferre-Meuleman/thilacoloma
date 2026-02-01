#!/bin/bash

# Quick server management script using SSH keys
# Usage: ./manage-server.sh [command]

SERVER="root@84.252.101.243"
PROJECT_PATH="/var/www/thilacoloma"

case $1 in
    "logs")
        echo "📋 Showing recent logs..."
        ssh $SERVER "cd $PROJECT_PATH && tail -50 storage/logs/laravel.log"
        ;;
    "status")
        echo "📊 Server status..."
        ssh $SERVER "cd $PROJECT_PATH && php please about && echo '✅ Statamic is running'"
        ;;
    "fix")
        echo "🔧 Running permissions fix..."
        ssh $SERVER "cd $PROJECT_PATH && chown -R www-data:www-data storage bootstrap/cache content resources && chmod -R 775 storage bootstrap/cache content resources"
        ;;
    "cache")
        echo "🧹 Clearing caches..."
        ssh $SERVER "cd $PROJECT_PATH && php please cache:clear && php please stache:clear"
        ;;
    "connect")
        echo "🔗 Connecting to server..."
        ssh $SERVER
        ;;
    "deploy")
        echo "🚀 Running deployment..."
        ssh $SERVER "cd $PROJECT_PATH && git pull && composer install --no-dev && php please cache:clear"
        ;;
    *)
        echo "🛠️  Thilacoloma Server Management"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  logs     - Show recent Laravel logs"
        echo "  status   - Check server and Statamic status"  
        echo "  fix      - Run permissions fix script"
        echo "  cache    - Clear all caches"
        echo "  connect  - SSH into the server"
        echo "  deploy   - Run secure deployment"
        echo ""
        echo "Example: $0 status"
        ;;
esac
