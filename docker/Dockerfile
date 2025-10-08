FROM harbor.in.ac-versailles.fr/library/python:3.12-slim AS build

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get install -y --no-install-recommends build-essential=12.12 gcc=4:14.2.0-1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /capsule-api

RUN python -m venv /opt/venv --upgrade-deps
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api api
COPY cert cert
COPY migrations migrations
COPY nats nats
COPY spec spec
COPY app.py .
COPY config.py .
COPY exceptions.py .
COPY models.py .
COPY server.py .
COPY utils.py .

COPY ./docker/entrypoint.sh .

FROM harbor.in.ac-versailles.fr/library/python:3.12-slim AS run

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y; \
    rm -rf /var/lib/apt/lists/*; \
    apt-get clean

WORKDIR /capsule-api

COPY --from=build /opt/venv /opt/venv
COPY --from=build /capsule-api .

RUN groupadd --gid 3210 -r capsule-api && useradd --uid 65432 -r -g capsule-api capsule-api && \
    chown -R capsule-api:capsule-api /capsule-api && \
    chmod u+x entrypoint.sh

USER capsule-api:capsule-api

EXPOSE 5080
EXPOSE 5443

ENV TZ="Europe/Paris"
ENV PATH="/opt/venv/bin:$PATH"
ENV WORKERS="2"
ENV TIMEOUT="30"
ENV SSL="false"
ENV PLATFORM="development"
ENV PLATFORM_DESCRIPTION="Web Platform Management API"
# ENV DB_MIGRATE="upgrade" # or "downgrade"

ENTRYPOINT ["/capsule-api/entrypoint.sh"]
