#!/usr/bin/env bash

# TODO: try to fetch these params somewhere if possible

echo "Please, provide your gitlab access token:"
read -sr GITLAB_ACCESS_TOKEN

echo "Now, we need the project ID (you can get it through the gitlab api):"
read -sr GITLAB_PROJECT_ID

echo "What is the git branch you're fetching from (defaults to 'main')?"
read -r GIT_BRANCH

SLASH="%2F"

GITLAB_PROJECT_URL="https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}"
INSTALL_PATH="repository/files/install${SLASH}install.sh"
INSTALL_URL="${GITLAB_PROJECT_URL}/${INSTALL_PATH}/raw?ref=${GIT_BRANCH}"

echo "Fetching..."

curl -s -H "PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}" "${INSTALL_URL}" | bash && echo "...done!"
