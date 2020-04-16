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
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
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

# Go to ${FOLDER}
cd ${FOLDER}
 
# Download
info "Download"
## Uncomment if you have trouble with git/yarn.lock
# git reset --hard
git checkout master
git pull

# Build
info "Install and update dependencies"
yarn install

info "Build assets"
NODE_ENV=production yarn build

info "Migrate"
yarn migrate

## END Script #####################################
info "exiting ${SCRIPTNAME}"
exit 0
