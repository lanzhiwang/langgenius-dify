# base image
FROM python:3.10-slim-bookworm AS base
# [base 1/3] FROM docker.io/library/python:3.10-slim-bookworm@sha256:38ced5e623fb8a6b256826a9f1bbcf5247a05123d6b6cb3847c9cd6ba46ef9ac

WORKDIR /app/api
# [base 2/3] WORKDIR /app/api

# Install Poetry
ENV POETRY_VERSION=1.8.3
RUN pip install --no-cache-dir poetry==${POETRY_VERSION}
# [base 3/3] RUN pip install --no-cache-dir poetry==1.8.3

# Configure Poetry
ENV POETRY_CACHE_DIR=/tmp/poetry_cache
ENV POETRY_NO_INTERACTION=1
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_VIRTUALENVS_CREATE=true

FROM base AS packages
# FROM docker.io/library/python:3.10-slim-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc g++ libc-dev libffi-dev libgmp-dev libmpfr-dev libmpc-dev
# [packages 1/3] RUN
# apt-get update &&
# apt-get install -y --no-install-recommends gcc g++ libc-dev libffi-dev libgmp-dev libmpfr-dev libmpc-dev

# Install Python dependencies
COPY pyproject.toml poetry.lock ./
# [packages 2/3] COPY pyproject.toml poetry.lock ./

RUN poetry install --sync --no-cache --no-root
# [packages 3/3] RUN poetry install --sync --no-cache --no-root

# production stage
FROM base AS production
# FROM docker.io/library/python:3.10-slim-bookworm

ENV FLASK_APP=app.py
ENV EDITION=SELF_HOSTED
ENV DEPLOY_ENV=PRODUCTION
ENV CONSOLE_API_URL=http://127.0.0.1:5001
ENV CONSOLE_WEB_URL=http://127.0.0.1:3000
ENV SERVICE_API_URL=http://127.0.0.1:5001
ENV APP_WEB_URL=http://127.0.0.1:3000

EXPOSE 5001

# set timezone
ENV TZ=UTC

WORKDIR /app/api
# [production 1/6] WORKDIR /app/api

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl wget vim nodejs ffmpeg libgmp-dev libmpfr-dev libmpc-dev \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
# [production 2/6] RUN
# apt-get update &&
# apt-get install -y --no-install-recommends curl wget vim nodejs ffmpeg libgmp-dev libmpfr-dev libmpc-dev &&
# apt-get autoremove &&
# rm -rf /var/lib/apt/lists/*

# Copy Python environment and packages
ENV VIRTUAL_ENV=/app/api/.venv
COPY --from=packages ${VIRTUAL_ENV} ${VIRTUAL_ENV}
# [production 3/6] COPY --from=packages /app/api/.venv /app/api/.venv

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Copy source code
COPY . /app/api/
# [production 4/6] COPY . /app/api/

# Copy entrypoint
COPY docker/entrypoint.sh /entrypoint.sh
# [production 5/6] COPY docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
# [production 6/6] RUN chmod +x /entrypoint.sh

ARG COMMIT_SHA
ENV COMMIT_SHA=${COMMIT_SHA}

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
