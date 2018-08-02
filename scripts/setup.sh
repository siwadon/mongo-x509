#!/bin/bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

file_env MONGO_CERTS_DIR /etc/ssl/mongo
file_env MONGO_CERTS_PREFIX mongodb-
file_env MONGO_CERTS_SERVER_FILE "${MONGO_CERTS_PREFIX}server.pem"
file_env MONGO_CERTS_CA_FILE "${MONGO_CERTS_PREFIX}CA.pem"
file_env MONGO_CERTS_USER "CN=admin,OU=Snap,O=SnapLogic,L=San Mateo,ST=CA,C=US"

mkdir -p "$MONGO_CERTS_DIR"

if [ ! -f "${MONGO_CERTS_DIR}/$MONGO_CERTS_SERVER_FILE" ]; then
    echo "Cannot find $MONGO_CERTS_SERVER_FILE in $MONGO_CERTS_DIR"
    exit 1
fi

if [ ! -f "${MONGO_CERTS_DIR}/$MONGO_CERTS_CA_FILE" ]; then
    echo "Cannot find $MONGO_CERTS_CA_FILE in $MONGO_CERTS_DIR"
    exit 1
fi

# TODO: Skip if already initialized 
# https://github.com/docker-library/mongo/blob/e0735c07abced69a5d8945aace9285288d013a83/3.6/docker-entrypoint.sh#L212
create-user.sh "$MONGO_CERTS_USER"

docker-entrypoint.sh "$@" \
	--sslPEMKeyFile "$MONGO_CERTS_DIR/$MONGO_CERTS_SERVER_FILE" \
  --sslCAFile "$MONGO_CERTS_DIR/$MONGO_CERTS_CA_FILE"

