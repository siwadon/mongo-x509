# mongo-x509
MongoDB with x.509 Certificates Authentication

## How to use this image
```bash
docker run -ti --rm -v $(pwd)/certs:/etc/ssl/mongo -p 27017:27017 siwadon/mongo-x509
```

then login from mongo shell by
```bash
mongo admin --ssl \
    --sslPEMKeyFile certs/mongodb-client.pem \
    --sslCAFile certs/mongodb-CA.pem \
    --authenticationDatabase '$external' \
    --authenticationMechanism MONGODB-X509 \
    --username "C=US,ST=CA,L=San Mateo,O=SnapLogic,OU=Snap,CN=admin"
```

## Environment Variables

| Name                       | Default            | Description |
| -------------------------- | ------------------ | ----------- |
| MONGO\_CERTS\_DIR          | /etc/ssl/mongo     |  |
| MONGO\_CERTS\_PREFIX       | mongodb-           |  |
| MONGO\_CERTS\_SERVER\_FILE | mongodb-server.pem |  |
| MONGO\_CERTS\_CA\_FILE     | mongodb-CA.pem     |  |
| MONGO\_CERTS\_USER         | CN=admin,OU=Snap,O=SnapLogic,L=San Mateo,ST=CA,C=US |  |


## Resources

 - [Use x.509 Certificates to Authenticate Clients - MongoDB](https://docs.mongodb.com/manual/tutorial/configure-x509-client-authentication/)
 - [rzhilkibaev/mongo-x509-auth-ssl](https://github.com/rzhilkibaev/mongo-x509-auth-ssl)
