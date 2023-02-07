FROM node:18.12.1
WORKDIR /app
COPY package.json .
RUN npm i
COPY . .
EXPOSE 5173
CMD ["npm", "run", "serve", "--", "--port", "5173"]