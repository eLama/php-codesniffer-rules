#!/bin/sh

set -ex

git fetch origin master:master || true
FORK_POINT=$(git merge-base --octopus master)
FILES=$(git diff --diff-filter=AMRC --name-only ${FORK_POINT} | grep .php | tr "\n" " ")

if [ -z "$FILES" ]
then
    exit
fi

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION;')
IGNORED_DIRS=${1}

WORKDIR="`pwd`"

PHPCS=$(dirname "$0")/phpcs

$PHPCS -p -v \
    --standard="${WORKDIR}"/vendor/elama/php-codesniffer-rules/Elama_PHP${PHP_VERSION}/ruleset.xml \
    --ignore=${IGNORED_DIRS} \
    --report=checkstyle \
    --extensions=php \
    --report-file="${WORKDIR}"/checkstyle-result.xml \
    --encoding=utf-8 \
    ${FILES}
