FROM node:14

WORKDIR /usr/src/app

COPY . ./
RUN npm install

EXPOSE 9003

ENV HOST=0.0.0.0
ENV PORT=9003

RUN npm run build

CMD [ "npm", "run", "start" ]