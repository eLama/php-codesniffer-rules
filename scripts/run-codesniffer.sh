#!/bin/bash
set -ex

git fetch origin master:master
fork_point=$(git merge-base --octopus master)
FILES=$(git diff --diff-filter=AMRC --name-only ${fork_point} | grep .php | tr "\n" " ")

WORKDIR="`pwd`"

cd $( dirname "$0" )

BIN_DIR="`pwd`"
PHP_VERSION=$( php -r 'echo PHP_MAJOR_VERSION;' )
IGNORED_DIRS=${1}

if [ "$FILES" != "" ]
then
    cd "${WORKDIR}"

    "${BIN_DIR}"/phpcs -p -v \
    --standard="${WORKDIR}"/vendor/elama/php-codesniffer-rules/Elama_PHP${PHP_VERSION}/ruleset.xml \
    --ignore=${IGNORED_DIRS} \
    --report=checkstyle \
    --extensions=php \
    --report-file="${WORKDIR}"/checkstyle-result.xml \
    --encoding=utf-8 \
    ${FILES}
fi
