FROM node:12
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)

# copy the app, note .dockerignore
COPY . /usr/src/app

COPY package*.json ./
# build necessary, even if no static files are needed,
# since it builds the server as well

RUN npm install
RUN npm run build
# If you are building your code for production
# RUN npm ci --only=production

# set app serving to permissive / assigned
ENV NUXT_HOST=0.0.0.0
# set app port
ENV NUXT_PORT=9003

# start the app
CMD [ "npm", "start" ]