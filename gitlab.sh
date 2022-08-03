#!/usr/bin/env bash

BOLD=$(tput bold)
NORMAL=$(tput sgr0)
RED="\033[1;31m"
GREEN="\033[1;32m"
GRAY="\033[1;37m"
ENDCOLOR="\033[0m"

GITLAB_ACCESS_TOKEN="$1"
if [ -z "$GITLAB_ACCESS_TOKEN" ]; then
    msg="${BOLD}Please, provide your gitlab access token${NORMAL}"
    msg="${msg} ${GRAY}[output is hidden]: ${ENDCOLOR}"
    echo -en "$msg"
    read -sr GITLAB_ACCESS_TOKEN
    echo
fi

GITLAB_PROJECT_ID="$2"
if [ -z "$GITLAB_PROJECT_ID" ];then
    echo -en "${BOLD}Now, we need the project ID:${NORMAL} "
    read -r GITLAB_PROJECT_ID
fi

GIT_BRANCH="$3"
if [ -z "$GIT_BRANCH" ]; then
    echo -en "${BOLD}What is the git branch?${NORMAL} ${GRAY}[default is 'main']:${ENDCOLOR} "
    read -r GIT_BRANCH
fi

INSTALL_PATH="$4"
if [ -z "$INSTALL_PATH" ]; then
    msg="${BOLD}What is the install.sh path?${NORMAL}"
    msg="${msg} ${GRAY}[default is 'install/install.sh']${ENDCOLOR}"
    echo -en "$msg"
    read -r INSTALL_PATH
fi

SLASH="%2F"
INSTALL_PATH=$(echo "$INSTALL_PATH" | sed -e 's/\//%2F/')

GITLAB_PROJECT_URL="https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}"
FULL_INSTALL_PATH="repository/files/${INSTALL_PATH:-install${SLASH}install.sh}"
INSTALL_URL="${GITLAB_PROJECT_URL}/${FULL_INSTALL_PATH}/raw?ref=${GIT_BRANCH:-main}"

echo "Fetching $INSTALL_URL."

HEADERS="PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN"
STATUS_CODE=$(curl -s -H "$HEADERS" "$INSTALL_URL" -o /tmp/gl-install.sh -w "%{http_code}")
if [ "$STATUS_CODE" != "200" ]; then
    echo "Error requesting install script."
    cat /tmp/gl-install.sh
    EXIT_CODE=1
else
    bash /tmp/gl-install.sh "$GITLAB_ACCESS_TOKEN" && echo "...done!"
    EXIT_CODE=0
fi

rm /tmp/gl-install.sh
exit $EXIT_CODE
