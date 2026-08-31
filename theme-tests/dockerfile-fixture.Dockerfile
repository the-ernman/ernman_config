FROM alpine:3.20
# Comment
ARG APP_HOME=/opt/theme-tests
ENV APP_ENV=test \
    APP_DEBUG=false \
    APP_PORT=8080

WORKDIR ${APP_HOME}

RUN adduser -D fixture \
    && mkdir -p ${APP_HOME}/bin ${APP_HOME}/data \
    && printf '%s\n' '#!/bin/sh' 'echo theme-fixture' > ${APP_HOME}/bin/run.sh \
    && chmod +x ${APP_HOME}/bin/run.sh

COPY <<'EOF' ${APP_HOME}/config.txt
name=fixture
enabled=true
EOF

USER fixture
EXPOSE 8080
CMD ["/opt/theme-tests/bin/run.sh"]
