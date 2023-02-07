FROM node:18.12.1
COPY package.json .
WORKDIR /app
RUN npm i
COPY . .
EXPOSE 5173
CMD ["npm", "run", "serve"]