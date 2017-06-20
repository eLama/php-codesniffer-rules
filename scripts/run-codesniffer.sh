#!/bin/sh

set -ex

git fetch origin master:master || true
FORK_POINT=$(git merge-base --octopus master)
FILES=$(git diff --diff-filter=AMRC --name-only ${FORK_POINT} | grep .php | tr "\n" " ")

if [ -z "$FILES" ]
then
    exit
fi

WORKDIR="`pwd`"

cd $( dirname "$0" )

BIN_DIR="`pwd`"
PHP_VERSION=$( php -r 'echo PHP_MAJOR_VERSION;' )
IGNORED_DIRS=${1}

cd "${WORKDIR}"

"${BIN_DIR}"/phpcs -p -v \
    --standard="${WORKDIR}"/vendor/elama/php-codesniffer-rules/Elama_PHP${PHP_VERSION}/ruleset.xml \
    --ignore=${IGNORED_DIRS} \
    --report=checkstyle \
    --extensions=php \
    --report-file="${WORKDIR}"/checkstyle-result.xml \
    --encoding=utf-8 \
    ${FILES}
