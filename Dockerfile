FROM node:7.1-alpine
WORKDIR /app
COPY package.json /app
COPY . /app
RUN npm install
EXPOSE 3000 3001 3002
ENTRYPOINT ["npm", "start"]
