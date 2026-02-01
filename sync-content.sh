#!/bin/bash

# Content Sync Script for Thila Coloma Statamic
# Synchronizes content between local development and VPS
# Uses rsync for conflict detection and intelligent syncing

set -e  # Exit on any error

# Configuration
SERVER="vps-thila"
REMOTE_PATH="/var/www/thilacoloma"
LOCAL_PATH="$(pwd)"
CONTENT_DIRS=("content/collections" "content/globals" "content/trees" "content/assets_meta.yaml")

# Kleuren voor output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; exit 1; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

check_connection() {
    log "Checking server connection..."
    if ! ssh -q "$SERVER" exit; then
        error "Cannot connect to $SERVER. Check your SSH config."
    fi
}

backup_local() {
    local backup_dir="backups/local_$(date '+%Y%m%d_%H%M%S')"
    log "Creating local backup in $backup_dir..."
    mkdir -p "$backup_dir"
    cp -r content "$backup_dir/"
}

backup_remote() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    log "Creating remote backup on server..."
    ssh "$SERVER" "mkdir -p $REMOTE_PATH/backups/server_$timestamp && cp -r $REMOTE_PATH/content $REMOTE_PATH/backups/server_$timestamp/"
}

show_diff() {
    log "🔎 Checking for differences (Dry Run)..."
    echo "============================================"
    # Check each directory defined in CONTENT_DIRS
    for dir in "${CONTENT_DIRS[@]}"; do
        if [ -e "$dir" ]; then
            rsync -avn --delete -e ssh "$dir/" "$SERVER:$REMOTE_PATH/$dir/"
        fi
    done
    echo "============================================"
    echo "Lines starting with 'deleting' means it exists on Server but not Local."
    echo "Lines starting with file names means Local is newer/different than Server."
}

sync_push() {
    check_connection
    show_diff
    
    echo ""
    if [ "$1" != "--force" ]; then
        read -p "⚠️  Are you sure you want to OVERWRITE the server with local content? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            warning "Push cancelled."
            exit 0
        fi
    fi

    backup_remote
    
    log "🚀 Pushing content to server..."
    for dir in "${CONTENT_DIRS[@]}"; do
        if [ -e "$dir" ]; then
            rsync -av --delete -e ssh "$dir/" "$SERVER:$REMOTE_PATH/$dir/"
        fi
    done

    log "🧹 Clearing server caches..."
    ssh "$SERVER" "cd $REMOTE_PATH && php please cache:clear && php please stache:clear && chown -R www-data:www-data content"
    
    success "Push complete! Server is now identical to Local."
}

sync_pull() {
    check_connection
    
    log "📥 Pulling content from server..."
    # Rsync dry-run reverse to see what would change
    rsync -avn --delete -e ssh "$SERVER:$REMOTE_PATH/content/" content/
    
    echo ""
    read -p "⚠️  This will OVERWRITE your local content with server data. Continue? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warning "Pull cancelled."
        exit 0
    fi

    backup_local
    
    rsync -av --delete -e ssh "$SERVER:$REMOTE_PATH/content/" content/
    
    log "🧹 Refreshing local cache..."
    php please stache:clear
    
    success "Pull complete! Local is now identical to Server."
}

sync_auto() {
    log "🤖 Auto-Sync: Checking GitHub..."
    git fetch origin master
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/master)
    
    if [ "$LOCAL" != "$REMOTE" ]; then
        log "📥 Updates found on GitHub. Pulling..."
        git pull origin master
        log "🚀 Deploying updates to Server..."
        sync_push --force
    else
        success "System is up-to-date."
    fi
}

case "$1" in
    "--push") sync_push "$2" ;;
    "--pull") sync_pull ;;
    "--diff") show_diff ;;
    "--auto") sync_auto ;;
    *)
        echo "Usage: ./sync-content.sh [--push | --pull | --diff | --auto]"
        ;;
esac
