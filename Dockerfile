FROM node:7.1-alpine
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build 
EXPOSE 3000 3001 3002
ENTRYPOINT ["npm", "start"]
