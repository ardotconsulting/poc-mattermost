# Mattermost preview: one container with built-in database (demo only, not production).
# The database lives on the persistent volume at /mattermost/data, so channels and
# the admin account survive redeploys. Tested with mattermost-preview:12.1.0.
FROM mattermost/mattermost-preview:12.1.0

# Set the site URL so the app generates correct links
ENV MM_SERVICESETTINGS_SITEURL=https://mattermost.poc.ardotconsulting.com

# Copy the admin setup script into the container
COPY setup-admin.sh /setup-admin.sh
RUN chmod +x /setup-admin.sh

EXPOSE 8065
