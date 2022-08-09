FROM node:lts-alpine3.16
WORKDIR /app
ADD . .
EXPOSE 8080
RUN npm install total4
CMD [ "node", "index.js", "8080" ]
