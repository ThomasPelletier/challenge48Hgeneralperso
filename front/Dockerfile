FROM node:18.12.1
COPY package.json .
WORKDIR /app
RUN npm i
COPY . .
EXPOSE 8080
CMD ["npm", "run", "serve", "2>&1"]