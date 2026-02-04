#!/bin/bash

# Content Sync Script for Thila Coloma Statamic
# Synchronizes content between local development, VPS, and GitHub
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
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; exit 1; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
info() { echo -e "${CYAN}ℹ️  $1${NC}"; }

fix_server_permissions() {
    log "🔧 Fixing server permissions..."
    ssh "$SERVER" << 'ENDSSH'
        cd /var/www/thilacoloma
        
        # Set ownership
        sudo chown -R www-data:www-data . 2>/dev/null || true
        
        # Set base permissions
        sudo find . -type d -exec chmod 755 {} \; 2>/dev/null || true
        sudo find . -type f -exec chmod 644 {} \; 2>/dev/null || true
        
        # Set writable directories
        sudo chmod -R 775 storage bootstrap/cache content public/assets resources/views 2>/dev/null || true
        
        # Make scripts executable
        sudo chmod +x artisan please *.sh 2>/dev/null || true
        
        # Clear caches as www-data user
        sudo -u www-data php artisan cache:clear 2>/dev/null || true
        sudo -u www-data php please cache:clear 2>/dev/null || true
        sudo -u www-data php please stache:clear 2>/dev/null || true
ENDSSH
    success "Permissions fixed"
}

check_connection() {
    log "Checking server connection..."
    if ! ssh -q "$SERVER" exit; then
        error "Cannot connect to $SERVER. Check your SSH config."
    fi
    success "Server connection OK"
}

check_local_git_status() {
    # Check for uncommitted local changes
    if [[ -n $(git status --porcelain content/) ]]; then
        return 1
    fi
    return 0
}

check_server_git_status() {
    # Check if server has unpushed commits
    local server_status=$(ssh "$SERVER" "cd $REMOTE_PATH && git status --porcelain content/ 2>/dev/null" || echo "")
    if [[ -n "$server_status" ]]; then
        return 1
    fi
    return 0
}

get_file_mod_times() {
    local location=$1  # "local" or "server"
    if [ "$location" = "local" ]; then
        find content -type f -name "*.yaml" -o -name "*.md" 2>/dev/null | while read f; do
            echo "$(stat -f '%m' "$f" 2>/dev/null || stat -c '%Y' "$f" 2>/dev/null) $f"
        done | sort -rn | head -10
    else
        ssh "$SERVER" "cd $REMOTE_PATH && find content -type f \( -name '*.yaml' -o -name '*.md' \) -exec stat -c '%Y %n' {} \; 2>/dev/null" | sort -rn | head -10
    fi
}

backup_local() {
    local backup_dir="backups/local_$(date '+%Y%m%d_%H%M%S')"
    log "Creating local backup in $backup_dir..."
    mkdir -p "$backup_dir"
    cp -r content "$backup_dir/"
    success "Local backup created"
}

backup_remote() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    log "Creating remote backup on server..."
    ssh "$SERVER" "mkdir -p $REMOTE_PATH/backups/server_$timestamp && cp -r $REMOTE_PATH/content $REMOTE_PATH/backups/server_$timestamp/"
    success "Server backup created"
}

show_diff() {
    log "🔎 Checking for differences between Local and Server..."
    echo ""
    echo "============================================"
    echo "  DIFFERENCES: LOCAL vs SERVER"
    echo "============================================"
    
    local has_diff=false
    
    for dir in "${CONTENT_DIRS[@]}"; do
        if [ -e "$dir" ]; then
            local diff_output=$(rsync -avn --delete -e ssh "$dir/" "$SERVER:$REMOTE_PATH/$dir/" 2>&1 | grep -v "^$" | grep -v "^sending" | grep -v "^total size" | grep -v "^sent " || true)
            if [[ -n "$diff_output" ]]; then
                has_diff=true
                echo -e "${YELLOW}📁 $dir:${NC}"
                echo "$diff_output" | while read line; do
                    if [[ "$line" == deleting* ]]; then
                        echo -e "  ${RED}← Server only:${NC} ${line#deleting }"
                    elif [[ -n "$line" && "$line" != "./" ]]; then
                        echo -e "  ${GREEN}→ Local newer:${NC} $line"
                    fi
                done
                echo ""
            fi
        fi
    done
    
    if [ "$has_diff" = false ]; then
        success "No differences found! Local and Server are in sync."
    fi
    
    echo "============================================"
}

detect_conflicts() {
    log "🔍 Scanning for potential conflicts..."
    
    local conflicts=false
    
    # Check local uncommitted changes
    if ! check_local_git_status; then
        warning "Local has uncommitted changes in content/"
        echo "    Changed files:"
        git status --porcelain content/ | head -5 | while read line; do
            echo "    - $line"
        done
        conflicts=true
    fi
    
    # Check server uncommitted changes  
    if ! check_server_git_status; then
        warning "Server has uncommitted changes in content/"
        conflicts=true
    fi
    
    if [ "$conflicts" = true ]; then
        return 1
    fi
    
    success "No conflicts detected"
    return 0
}

sync_push() {
    check_connection
    
    # Check for conflicts first
    if ! detect_conflicts && [ "$1" != "--force" ]; then
        echo ""
        warning "Potential conflicts detected!"
        warning "Run './sync-content.sh from-server' first to get latest changes,"
        warning "or use '--force' to overwrite anyway."
        exit 1
    fi
    
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

    fix_server_permissions
    
    success "Push complete! Server content is now identical to Local."
}

sync_pull() {
    check_connection
    
    # Check for local uncommitted changes
    if ! check_local_git_status && [ "$1" != "--force" ]; then
        warning "You have uncommitted local changes in content/"
        echo "    Commit them first, or use '--force' to overwrite."
        exit 1
    fi
    
    log "📥 Checking what would be pulled from server..."
    echo ""
    
    # Show what would change
    rsync -avn --delete -e ssh "$SERVER:$REMOTE_PATH/content/" content/ 2>&1 | grep -v "^$" | grep -v "^receiving" | grep -v "^total size" | grep -v "^sent " | while read line; do
        if [[ "$line" == deleting* ]]; then
            echo -e "  ${RED}Will delete local:${NC} ${line#deleting }"
        elif [[ -n "$line" && "$line" != "./" ]]; then
            echo -e "  ${GREEN}Will update:${NC} $line"
        fi
    done
    
    echo ""
    if [ "$1" != "--force" ]; then
        read -p "⚠️  This will OVERWRITE your local content with server data. Continue? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            warning "Pull cancelled."
            exit 0
        fi
    fi

    backup_local
    
    rsync -av --delete -e ssh "$SERVER:$REMOTE_PATH/content/" content/
    
    log "🧹 Refreshing local cache..."
    php please stache:clear 2>/dev/null || php artisan cache:clear 2>/dev/null || true
        # Fix server permissions to ensure everything is writable
    fix_server_permissions
        success "Pull complete! Local content is now identical to Server."
    
    # Offer to commit the changes
    echo ""
    read -p "Would you like to commit these changes to git? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add content/
        git commit -m "[SYNC] Pulled content from server $(date '+%Y-%m-%d %H:%M')"
        success "Changes committed to git"
    fi
}

sync_auto() {
    log "🤖 Auto-Sync: Full synchronization workflow..."
    echo ""
    
    # Step 1: Check GitHub for updates
    log "Step 1: Checking GitHub for updates..."
    git fetch origin master 2>/dev/null || git fetch origin main 2>/dev/null || true
    LOCAL=$(git rev-parse HEAD 2>/dev/null || echo "")
    REMOTE=$(git rev-parse origin/master 2>/dev/null || git rev-parse origin/main 2>/dev/null || echo "")
    
    if [ -n "$REMOTE" ] && [ "$LOCAL" != "$REMOTE" ]; then
        log "📥 Updates found on GitHub. Pulling..."
        git pull origin master 2>/dev/null || git pull origin main 2>/dev/null || true
    else
        info "GitHub is up-to-date."
    fi
    
    # Step 2: Pull any server changes
    log "Step 2: Checking server for content updates..."
    check_connection
    
    # Check if server has newer content
    local server_has_changes=$(ssh "$SERVER" "cd $REMOTE_PATH && git status --porcelain content/" || echo "")
    if [[ -n "$server_has_changes" ]]; then
        warning "Server has unpushed content changes!"
        info "These were likely made via Statamic Control Panel."
        echo ""
        read -p "Pull server changes to local? (Y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            sync_pull --force
        fi
    fi
    
    # Step 3: Push local to server
    log "Step 3: Syncing local to server..."
    show_diff
    
    success "Auto-sync complete!"
}

full_sync() {
    log "🔄 Full bidirectional sync workflow..."
    echo ""
    
    check_connection
    
    # Step 1: Show current status
    log "Current sync status:"
    show_diff
    
    echo ""
    echo "============================================"
    echo "  RECOMMENDED ACTIONS"
    echo "============================================"
    
    # Check what direction to sync
    if ! check_server_git_status; then
        info "Server has changes not in git → Pull from server first"
        echo "    Run: ./sync-content.sh from-server"
    elif ! check_local_git_status; then
        info "Local has uncommitted changes → Push to server"
        echo "    Run: ./sync-content.sh to-server"  
    else
        success "Everything appears to be in sync!"
    fi
    
    echo "============================================"
}

# Deploy templates/views to server with proper permissions
deploy_templates() {
    check_connection
    
    log "📄 Deploying templates to server..."
    
    rsync -av --delete -e ssh "resources/views/" "$SERVER:$REMOTE_PATH/resources/views/"
    rsync -av --delete -e ssh "resources/blueprints/" "$SERVER:$REMOTE_PATH/resources/blueprints/"
    
    fix_server_permissions
    
    success "Templates deployed! Changes are now live."
}

# Quick deploy single file with permission fix
deploy_file() {
    local file="$1"
    if [ -z "$file" ]; then
        error "Usage: ./sync-content.sh deploy-file <relative-path>"
    fi
    
    check_connection
    
    log "📄 Deploying $file to server..."
    scp "$file" "$SERVER:$REMOTE_PATH/$file"
    
    fix_server_permissions
    
    success "File deployed: $file"
}

show_status() {
    log "📊 Content Sync Status"
    echo ""
    
    check_connection
    
    echo "Local Git Status (content/):"
    git status --porcelain content/ | head -10 || echo "  Clean"
    
    echo ""
    echo "Server Git Status (content/):"
    ssh "$SERVER" "cd $REMOTE_PATH && git status --porcelain content/" | head -10 || echo "  Clean"
    
    echo ""
    echo "Recent Local Changes:"
    get_file_mod_times "local" | head -5 | while read ts file; do
        echo "  $(date -r "$ts" '+%Y-%m-%d %H:%M' 2>/dev/null || date -d "@$ts" '+%Y-%m-%d %H:%M' 2>/dev/null) $file"
    done
    
    echo ""
    echo "Recent Server Changes:"
    get_file_mod_times "server" | head -5 | while read ts file; do
        echo "  $(date -r "$ts" '+%Y-%m-%d %H:%M' 2>/dev/null || date -d "@$ts" '+%Y-%m-%d %H:%M' 2>/dev/null) $file"
    done
}

print_usage() {
    echo "
${CYAN}Thila Coloma Content Sync${NC}
Synchronize content between local development and VPS server.

${GREEN}Usage:${NC}
    ./sync-content.sh <command> [options]

${GREEN}Commands:${NC}
    ${YELLOW}from-server${NC}     Pull content FROM server TO local
    ${YELLOW}to-server${NC}       Push content FROM local TO server
    ${YELLOW}deploy-templates${NC} Deploy views & blueprints to server
    ${YELLOW}deploy-file${NC}     Deploy single file (e.g. deploy-file resources/views/meer.antlers.html)
    ${YELLOW}--diff${NC}          Show differences without making changes
    ${YELLOW}--auto${NC}          Full auto-sync: GitHub → Local → Server
    ${YELLOW}full-sync${NC}       Check status and recommend sync direction
    ${YELLOW}status${NC}          Show current sync status
    ${YELLOW}check${NC}           Test server connection

${GREEN}Options:${NC}
    ${YELLOW}--force${NC}         Skip confirmation prompts

${GREEN}Examples:${NC}
    ./sync-content.sh from-server          # Get latest from server
    ./sync-content.sh to-server            # Push changes to server
    ./sync-content.sh to-server --force    # Push without confirmation
    ./sync-content.sh --diff               # Preview changes
    ./sync-content.sh status               # Check current state

${GREEN}Workflow:${NC}
    1. After editing in Statamic CP → run 'from-server'
    2. After editing local files   → run 'to-server'
    3. For automated full sync     → run '--auto'
"
}

# Main command routing
case "$1" in
    "to-server"|"--push") sync_push "$2" ;;
    "from-server"|"--pull") sync_pull "$2" ;;
    "deploy-templates") deploy_templates ;;
    "deploy-file") deploy_file "$2" ;;
    "--diff"|"diff") show_diff ;;
    "--auto"|"auto") sync_auto ;;
    "full-sync"|"sync") full_sync ;;
    "status") show_status ;;
    "check") check_connection ;;
    "--help"|"-h"|"help") print_usage ;;
    *)
        print_usage
        ;;
esac
