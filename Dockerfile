FROM node:21
RUN mkdir -p /home/frontend
COPY . /home/frontend

run mkdir -p /home/backend
COPY . /home/backend
CMD ["cd", "/home/backend"]
CMD ["npm", "install"]
CMD ["npx", "run", "serve"]
EXPOSE 8080

run mkdir -p /home/frontend
COPY . /home/frontend
CMD ["cd", "/home/frontend"]
CMD ["npm", "install"]
CMD ["npx", "run", "serve"]
EXPOSE 8081
