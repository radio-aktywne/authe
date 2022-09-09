ARG KRATOS_IMAGE_TAG=v0.10.1

FROM oryd/kratos:$KRATOS_IMAGE_TAG

USER root

WORKDIR /app

COPY ./authe/start.sh ./start.sh
RUN chmod +x ./start.sh

COPY ./authe/conf/ ./conf/

ENV AUTHE_PORT=23000 \
    AUTHE_ADMIN_PORT=23001 \
    AUTHE_DB_ADDRESS=authe-db:22000 \
    AUTHE_DB_PASSWORD=password \
    AUTHE_AUTHGATE_PUBLIC_URL=https://localhost:20000 \
    AUTHE_ADMIN_PUBLIC_URL=https://localhost:23001 \
    AUTHE_ALLOWED_RETURN_URLS=http://*.localhost,https://*.localhost,http://localhost,https://localhost \
    AUTHE_COOKIE_DOMAIN=localhost

EXPOSE 23000
EXPOSE 23001

ENTRYPOINT ["./start.sh"]
CMD []
