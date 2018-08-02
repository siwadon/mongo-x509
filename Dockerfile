FROM mongo:3.6

COPY scripts/create-user.sh /usr/local/bin
COPY scripts/setup.sh /usr/local/bin

ENTRYPOINT ["setup.sh"]

CMD ["mongod", "--auth", "--sslMode", "requireSSL", "--clusterAuthMode", "x509" ]
