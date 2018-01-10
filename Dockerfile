FROM php:alpine

COPY ["Elama_PHP", "/rulesets/Elama_PHP"]
COPY ["Elama_PHP5", "/rulesets/Elama_PHP5"]
COPY ["Elama_PHP7", "/rulesets/Elama_PHP7"]

RUN curl -L https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -o /usr/bin/phpcs && \
    chmod +x /usr/bin/phpcs && \
    phpcs --config-set installed_paths /rulesets && \
    phpcs --config-set default_standard Elama_PHP7

ENTRYPOINT ["phpcs"]
