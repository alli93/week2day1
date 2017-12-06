# Set base image to node:carbon
FROM node:carbon

# Sets the working directory to /code
WORKDIR /code

# Copy package.json into the working directory
COPY package.json package.json

# Copy app.js into the working directory
COPY app.js app.js

# Run npm installer which installs dependencies
RUN npm install 

# Declare entrypoint for the node
CMD node app.js