FROM node:18.12.1
WORKDIR /app
RUN npm i
COPY package.json .
COPY . .
EXPOSE 5173
CMD ["npm", "run", "serve"]