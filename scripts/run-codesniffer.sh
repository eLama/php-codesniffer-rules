#!/bin/bash
set -ex

git fetch origin master:master
fork_point=$(git merge-base --octopus master)
FILES=$(git diff --diff-filter=AMRC --name-only ${fork_point} | grep .php | tr "\n" " ")

PHP_VERSION=$( php -r 'echo PHP_MAJOR_VERSION;' )
ROOT_DIR = $( cd .. && echo ${PWD##*/} )

if [ ${ROOT_DIR} -eq 'vendor' ]
then
    VENDOR_DIR=..
else
    VENDOR_DIR=vendor
fi

IGNORED_DIRS=${1}

if [ "$FILES" != "" ]
then
    ./phpcs -p -v
    --standard=${VENDOR_DIR}/elama/php-codesniffer-rules/Elama_PHP${PHP_VERSION}/ruleset.xml \
    --ignore=${IGNORED_DIRS} \
    --report=checkstyle \
    --extensions=php \
    --report-file=${VENDOR_DIR}/../build/checkstyle-result.xml \
    --encoding=utf-8 \
    ${FILES}
fi
