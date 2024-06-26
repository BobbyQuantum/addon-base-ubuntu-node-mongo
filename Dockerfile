ARG BUILD_FROM
FROM $BUILD_FROM

ARG NODE_VERSION
ARG MONGODB_VERSION

# Install Git, MongoDB, Node.js, clean up 
RUN apt-get update && apt-get install -y gnupg git && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc | \
    gpg --dearmor -o /usr/share/keyrings/mongodb-server-${MONGODB_VERSION}.gpg && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-${MONGODB_VERSION}.gpg ] \
    https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/${MONGODB_VERSION} multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list && \
    apt-get update && apt-get install -y mongodb-org-server && \
    echo "mongodb-org-server hold" | dpkg --set-selections && \
    apt-get purge -y gnupg && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 
