#!/bin/sh
# setup-admin.sh — claim the admin account automatically after first deploy.
# The mattermost-preview image gives the admin role to its first user.
# This script waits for Mattermost to be ready, then creates the first user
# as admin@ardotconsulting.com with $ADMIN_PASSWORD via the REST API.
# If a user already exists (setup already done), it does nothing.
#
# Tools available in the mattermost-preview image: wget (busybox), sh.

set -e

MM_HOST="localhost"
MM_PORT="8065"
ADMIN_EMAIL="admin@ardotconsulting.com"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-}"
ADMIN_USERNAME="ardotadmin"

# Wait for Mattermost to respond
echo "Waiting for Mattermost to be ready..."
for i in $(seq 1 60); do
    code=$(wget -q -O /dev/null --spider "http://${MB_HOST}:${MB_PORT}/api/v4/system/ping" 2>/dev/null && echo "200" || echo "000")
    if [ "$code" = "200" ]; then
        echo "Mattermost is ready."
        break
    fi
    sleep 5
done

# Try to create the first user. On a fresh instance, the first user created
# becomes system_admin and no auth is required. On an instance that already
# has users, it fails — which means setup is already complete.
echo "Attempting to create admin user..."

PAYLOAD="{\"email\":\"${ADMIN_EMAIL}\",\"username\":\"${ADMIN_USERNAME}\",\"password\":\"${ADMIN_PASSWORD}\",\"first_name\":\"ARDOT\",\"last_name\":\"Admin\"}"

response=$(wget -q -O - --post-data="$PAYLOAD" \
    --header="Content-Type: application/json" \
    "http://${MM_HOST}:${MM_PORT}/api/v4/users" 2>&1 || true)

# Check if the response contains a user id (success)
if echo "$response" | grep -q '"id":"[a-z0-9]*"'; then
    echo "Admin account created successfully."
    exit 0
fi

# Check if it failed because the user already exists
if echo "$response" | grep -q "already exists\|user with this email"; then
    echo "Admin account already exists. Nothing to do."
    exit 0
fi

# Check if user creation is disabled (means setup is done and restricted)
if echo "$response" | grep -q "user creation disabled\|not authorized\|permission"; then
    echo "User creation is restricted — setup is already complete. Nothing to do."
    exit 0
fi

echo "Setup response: $response"
echo "Admin setup may have failed. The first visitor may still need to claim admin manually."
exit 0
