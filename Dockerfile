ARG KRATOS_IMAGE_TAG=v0.10.1

FROM oryd/kratos:$KRATOS_IMAGE_TAG

USER root

WORKDIR /app

COPY ./authe/start.sh ./start.sh
RUN chmod +x ./start.sh

COPY ./authe/conf/ ./conf/

RUN chown -R ory /app/* /app/conf/*
USER ory

ENV AUTHE_PORT=23000 \
    AUTHE_ADMIN_PORT=23001 \
    AUTHE_DB_ADDRESS=authe-db:22000 \
    AUTHE_AUTHGATE_PUBLIC_URL=http://localhost:20000 \
    AUTHE_ALLOWED_RETURN_URLS=http://*.localhost,https://*.localhost,http://localhost,https://localhost

EXPOSE 23000
EXPOSE 23001

ENTRYPOINT ["./start.sh"]
CMD []
