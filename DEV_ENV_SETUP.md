# Zammad Devlopment Environment Setup

## 1. Install development dependencies
- a. NixOS

    Install DirEnv add-on in VSCode, then open the project in VSCode and enter the directory and wait for the prompt to install the dependencies.
- b. Ubuntu

    Follow this [link](https://github.com/stars-labs/zammad/blob/develop/doc/developer_manual/development_environment/how-to-set-up-a-development-environment.md) to install the dependencies.

## 2. Host the Zammad instance locally
```bash
pnpm install
npm install -g @coffeelint/cli
npm install -g stylelint

bundle install

cp config/database/database.yml config/database.yml
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# To reset the database if needed
# bin/rails db:reset

# Configure elasticsearch
rake zammad:searchindex:rebuild
rails c
# Set the basic Elasticsearch connection settings
Setting.set('es_url', 'http://localhost:9200')  # Use your local Elasticsearch URL
Setting.set('es_index', 'zammad')               # Default index name

# If your Elasticsearch requires authentication
# Setting.set('es_user', 'username')
# Setting.set('es_password', 'password')

# SSL verification (set to false if using self-signed certificates)
# Setting.set('es_ssl_verify', true)

# Exit the console
exit
```

## 3. If using cloudflare for external access
```bash
rails c
# Update WebSocket configuration to use path-based approach
Setting.set('websocket_backend', 'websocket')

# Make sure the domain name is correct
Setting.set('fqdn', 'yourdomain.com')  # Replace 'yourdomain.com' with your actual domain name

# Ensure HTTPS is being used
Setting.set('http_type', 'https')

# Exit the console
exit