# Fetching the latest node image on alpine linux
FROM node:20-alpine 

COPY sshd_config /etc/ssh/

# Setting up the work directory
WORKDIR /app

# Installing dependencies
COPY ./package*.json .

# Copying all the files in our project
COPY . .

RUN npm install

COPY entrypoint.sh /app/

# Start and enable SSH
RUN apk add openssh \
    && echo "root:Docker!" | chpasswd \
    && chmod +x /app/entrypoint.sh \
    && cd /etc/ssh/ \
    && ssh-keygen -A

COPY sshd_config /etc/ssh/

EXPOSE 3000 2222

ENTRYPOINT [ "/app/entrypoint.sh" ]

# # Starting our application
# CMD ["npm","run","start"]