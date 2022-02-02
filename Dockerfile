# using node-alpine as base image and tag this phase with a name
FROM node:16-alpine as builder  

WORKDIR '/app'

COPY package.json .

RUN npm install

# copying all of the source code
COPY . .

RUN npm run build

# path to the build folder will be '/app/build'

# Run phase starts here, using Nginx as base image
FROM nginx

# specify that this container needs a map to the port 80, so elastic beanstalk will read this expose instruction
# and it will create a port mapping for the container, similar to what we do with "docker run -p 80:80"
EXPOSE 80

# copy the build folder from the builder phase (the phase in charge of run npm run build)
# /usr/share/nginx/html is the target folder where we need to put the result of building the react app. See https://hub.docker.com/_/nginx
COPY --from=builder /app/build /usr/share/nginx/html

