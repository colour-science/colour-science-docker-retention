#!/bin/bash

ORG=colourscience

echo "Retrieving repository list ..."
REPO_LIST=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${ORG}/?page_size=100 | jq -r '.results|.[]|.name')

echo "Images and tags for organization: ${ORG}"

for i in ${REPO_LIST}
do
  echo "${i}:"
  TAGS=$(curl -s https://hub.docker.com/v2/repositories/${ORG}/${i}/tags/?page_size=100 | jq -r '.results|.[]|.name')
  for j in ${TAGS}
  do
    IMAGE="${ORG}/${i}:${j}"
    echo "Pulling: ${IMAGE}"
    docker pull "${IMAGE}"
  done
  docker system prune --all --force
done