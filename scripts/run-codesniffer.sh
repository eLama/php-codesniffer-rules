#!/bin/sh

set -ex

git fetch origin master:master || true
FORK_POINT=$(git merge-base --octopus master)
FILES=$(git diff -z --diff-filter=AMRC --name-only ${FORK_POINT} -- '*.php' | xargs -0)

if [ -z "$FILES" ]
then
    exit
fi

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION;')
IGNORED_DIRS=${1}

PHPCS=$(dirname "$0")/phpcs

$PHPCS --config-set installed_paths vendor/elama/php-codesniffer-rules

$PHPCS -p -v \
    --standard=Elama_PHP${PHP_VERSION} \
    --ignore=${IGNORED_DIRS} \
    --report=checkstyle \
    --report-file=checkstyle-result.xml \
    --encoding=utf-8 \
    ${FILES}
