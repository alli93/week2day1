#!/bin/bash

# Image credentials
image_name="app"
username="alli93"
repository="week1"
tag=$(git rev-parse --short HEAD)

echo "Git HEAD: ${tag}"

# Store environment 
echo "COMMIT_ID=${tag}" > .env
echo "Created .env file:"
cat .env

echo "Building..."
docker build -t app .
echo "Done!"

docker tag app ${username}/${repository}:${tag}

echo "Pushing image ${username}/${repository}:${tag} into docker repo"
docker push ${username}/${repository}:${tag}
echo "Done!"