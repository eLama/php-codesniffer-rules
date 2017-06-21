FROM php:alpine

RUN pear install PHP_CodeSniffer && \
    phpcs --config-set installed_paths /rulesets

WORKDIR /srv

ENTRYPOINT ["phpcs", "--report=checkstyle", "--report-file=checkstyle-result.xml", "-p"]

COPY ["Elama_PHP", "/rulesets/Elama_PHP"]
COPY ["Elama_PHP5", "/rulesets/Elama_PHP5"]
COPY ["Elama_PHP7", "/rulesets/Elama_PHP7"]
