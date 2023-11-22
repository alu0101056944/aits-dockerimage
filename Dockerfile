FROM node:21

# install sudo command. otherwise I get error sudo not found
RUN apt-get update && apt-get install -y sudo

# Install mongodb
RUN ["/bin/bash" , "-c", \
    "curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add"]
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" \
    | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
RUN bash -c \
    echo "deb  arch=amd64,arm64  https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
RUN sudo apt update
RUN sudo apt install mongodb-org
RUN sudo systemctl start mongod.service
RUN sudo systemctl enable mongod

# Output the current version, server address, and port.
RUN mongo --eval 'db.runCommand({ connectionStatus: 1 })'

# Make the backend
RUN mkdir -p /home/backend
COPY . /home/backend
RUN cd /home/backend
RUN npm install

# Make the frontend
run mkdir -p /home/frontend
COPY . /home/frontend
RUN cd /home/frontend
RUN npm install

# Initialize database
RUN cd /home/backend/mongo-scripts
RUN node create.js

RUN cd /home/backend
RUN npx run serve
EXPOSE 8080
RUN cd /home/frontend
RUN npx run serve
EXPOSE 8081
