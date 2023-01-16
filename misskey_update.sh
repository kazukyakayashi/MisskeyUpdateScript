#!/bin/bash
## author      : Dryusdan
## modified    : KazukyAkayashi
## date        : 16/04/2020
## description : Misskey Update

## Bash strict mode ####################################
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

## Bash color ##########################################
# Set colors
RED='\033[0;31m'
YELLOW='\033[00;33m'
LRED='\033[01;31m'
LBLUE='\033[01;34m'
NC='\033[0m' # No Color

## Logs ################################################
readonly SCRIPTNAME="$(basename "$0")"
info()    { echo -e "${LBLUE}[INFO] $* ${NC}"    | logger --tag "${SCRIPTNAME}" --stderr ; }
warning() { echo -e "${YELLOW}[WARNING] $* ${NC}" | logger --tag "${SCRIPTNAME}" --stderr ; }
error()   { echo -e "${LRED}[ERROR] $* ${NC}"   | logger --tag "${SCRIPTNAME}" --stderr ; }
fatal()   { echo -e "${RED}[FATAL] $* ${NC}"   | logger --tag "${SCRIPTNAME}" --stderr ; exit 1 ; }
########################################################

## Define Misskey's folder ##########################
FOLDER="/your/path/"
MISSKEYSERVICE="misskey.service"
MISSKEYUSER="misskey"

info "Stopping Misskey"
systemctl stop ${MISSKEYSERVICE}

# Go to ${FOLDER}
cd ${FOLDER}
 
# Download
info "Download"
## Uncomment if you have trouble with git/yarn.lock
# git reset --hard
su - ${MISSKEYUSER} -s /bin/bash -c "git checkout master"
su - ${MISSKEYUSER} -s /bin/bash -c "git pull"
su - ${MISSKEYUSER} -s /bin/bash -c "git submodule update --init"

# Build
info "Install and update dependencies"
su - ${MISSKEYUSER} -s /bin/bash -c "yarn install"

info "Build assets"
su - ${MISSKEYUSER} -s /bin/bash -c "NODE_ENV=production yarn build"

info "Migrate"
su - ${MISSKEYUSER} -s /bin/bash -c "yarn migrate"

info "Starting Misskey"
systemctl start ${MISSKEYSERVICE}

## END Script #####################################
info "exiting ${SCRIPTNAME}"
exit 0
