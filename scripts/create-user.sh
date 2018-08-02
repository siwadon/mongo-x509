#!/usr/bin/env bash

# Create a new mongo admin user, if not exists

set -eo pipefail
username=${1:-$MONGO_CERTS_USER}


# Start mongod, and wait until it is ready
mongod &
counter=5
sleep 2
while ! mongo admin --eval "quit();"; do   
    ((counter--))
    if [[ $counter = 0 ]];then
        break
    fi
    sleep 2
done


# Create new user if not exists
user=$(mongo admin --quiet --eval "db.getSiblingDB('\$external').getUser('$username');")

if [ "$user" == "null" ]; then
    echo "Creating user: $username"
    mongo admin --quiet --eval "db.getSiblingDB('\$external').runCommand({createUser: '$username', roles: [{ role: 'root', db: 'admin'}]});"
else
    echo "$username already exists"
fi


# Shutdown mongod
mongo admin -quiet --eval "db.shutdownServer({timeoutSecs: 3});"
