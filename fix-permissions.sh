#!/bin/bash

# Fix permissions script for Statamic deployment
# This script ensures all files have proper ownership and permissions for web server
# Usage: Run this script on the server as root: ./fix-permissions.sh

WEBSITE_DIR="/var/www/thilacoloma"
LOG_FILE="/var/log/thilacoloma-permissions.log"

# Function to log with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

log_message "🔧 Starting permission fix..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_message "❌ This script must be run as root"
    exit 1
fi

# Set proper ownership for the entire project
log_message "Setting ownership to www-data:www-data..."
chown -R www-data:www-data $WEBSITE_DIR

# Set proper permissions for directories
log_message "Setting directory permissions to 775..."
find $WEBSITE_DIR -type d -exec chmod 775 {} \;

# Set proper permissions for files  
log_message "Setting file permissions to 664..."
find $WEBSITE_DIR -type f -exec chmod 664 {} \;

# Set executable permissions for specific files
chmod 755 $WEBSITE_DIR/please
chmod 755 $WEBSITE_DIR/fix-permissions.sh
chmod 755 $WEBSITE_DIR/auto-fix-permissions.sh
chmod 644 $WEBSITE_DIR/.env*

# Fix storage and cache directories specifically
log_message "Fixing storage and cache permissions..."
chmod -R 775 $WEBSITE_DIR/storage
chmod -R 775 $WEBSITE_DIR/bootstrap/cache

# Remove any root-owned cache files and recreate structure
log_message "🗑️ Cleaning up root-owned cache files..."
find $WEBSITE_DIR/storage/framework/cache/data/stache/ -user root -delete 2>/dev/null || true
find $WEBSITE_DIR/bootstrap/cache/ -user root -delete 2>/dev/null || true

# Force remove and recreate problematic directories that often remain root-owned
log_message "🔧 Force recreating stache index directories..."
rm -rf $WEBSITE_DIR/storage/framework/cache/data/stache/indexes/entries 2>/dev/null || true
rm -rf $WEBSITE_DIR/storage/framework/cache/data/stache/indexes/collections 2>/dev/null || true

# Ensure Stache cache directories exist with correct ownership
mkdir -p /var/www/thilacoloma/storage/framework/cache/data/stache/indexes/{collections,taxonomies,navs,globals,assets,forms,users,entries/news,entries/pages}
chown -R www-data:www-data /var/www/thilacoloma/storage/framework/cache/data/stache/
chmod -R 775 /var/www/thilacoloma/storage/framework/cache/data/stache/

echo "✅ Permissions fixed successfully!"
echo "   - All files owned by www-data:www-data"
echo "   - Directories: 775 permissions"  
echo "   - Files: 664 permissions"
echo "   - Storage: 775 permissions"
echo "   - Cache: Cleaned and rebuilt"
