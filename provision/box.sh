#!/bin/bash

set -e

# Declare script variables
docroot="/global"

provision_env() {
    sudo yum install nodejs npm -y
    if [ -e "${docroot}/package.json" ]; then
        echo "+ Installing Node dependencies"
        npm install
    fi
}

# Run provisioning steps
cd $docroot;

echo "Provisioning Environment"
provision_env

exit 0
