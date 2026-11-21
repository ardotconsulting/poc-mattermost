# poc-mattermost

Proof of concept for [Self-Hosting Mattermost: Replace Slack with Your Own Team Chat Platform](https://www.ardotconsulting.com/blog/2026/10/08/self-hosting-mattermost-replace-slack-with-your-own-team-chat-platform/).

Runs [Mattermost](https://mattermost.com/) from the `mattermost/mattermost-preview` Docker image (v12.1.0) — a single container with a built-in database, suitable for demos but not production.

The admin account (`admin@ardotconsulting.com`) is claimed automatically on first deploy via the REST API. Ryan reads the generated password in Coolify's Environment Variables.

## Try it

Visit [https://mattermost.poc.ardotconsulting.com](https://mattermost.poc.ardotconsulting.com) and log in with `admin@ardotconsulting.com` / the password from Coolify, or create a new account.
