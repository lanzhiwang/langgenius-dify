# base image
FROM node:20.11-alpine3.19 AS base
# [base 1/2] FROM docker.io/library/node:20.11-alpine3.19@sha256:bf77dc26e48ea95fca9d1aceb5acfa69d2e546b765ec2abfb502975f1a2d4def

LABEL maintainer="takatost@gmail.com"

# if you located in China, you can use aliyun mirror to speed up
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache tzdata
# [base 2/2] RUN apk add --no-cache tzdata

############################################################################################################

# install packages
FROM base AS packages
# FROM docker.io/library/node:20.11-alpine3.19

WORKDIR /app/web
# [packages 1/4] WORKDIR /app/web

COPY package.json .
# [packages 2/4] COPY package.json .

COPY yarn.lock .
# [packages 3/4] COPY yarn.lock .

# if you located in China, you can use taobao registry to speed up
# RUN yarn install --frozen-lockfile --registry https://registry.npmmirror.com/

RUN yarn install --frozen-lockfile
# [packages 4/4] RUN yarn install --frozen-lockfile

############################################################################################################

# build resources
FROM base AS builder
# FROM docker.io/library/node:20.11-alpine3.19

WORKDIR /app/web
# [builder 1/4] WORKDIR /app/web

COPY --from=packages /app/web/ .
# [builder 2/4] COPY --from=packages /app/web/ .

COPY . .
# [builder 3/4] COPY . .

RUN yarn build
# [builder 4/4] RUN yarn build

############################################################################################################

# production stage
FROM base AS production
# FROM docker.io/library/node:20.11-alpine3.19

ENV NODE_ENV=production
ENV EDITION=SELF_HOSTED
ENV DEPLOY_ENV=PRODUCTION
ENV CONSOLE_API_URL=http://127.0.0.1:5001
ENV APP_API_URL=http://127.0.0.1:5001
ENV PORT=3000

# set timezone
ENV TZ=UTC
RUN ln -s /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone
# [production 1/8] RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

# global runtime packages
RUN yarn global add pm2 \
    && yarn cache clean
# [production 2/8] RUN yarn global add pm2 && yarn cache clean

WORKDIR /app/web
# [production 3/8] WORKDIR /app/web

COPY --from=builder /app/web/public ./public
# [production 4/8] COPY --from=builder /app/web/public ./public

COPY --from=builder /app/web/.next/standalone ./
# [production 5/8] COPY --from=builder /app/web/.next/standalone ./

COPY --from=builder /app/web/.next/static ./.next/static
# [production 6/8] COPY --from=builder /app/web/.next/static ./.next/static

COPY docker/pm2.json ./pm2.json
# [production 7/8] COPY docker/pm2.json ./pm2.json

COPY docker/entrypoint.sh ./entrypoint.sh
# [production 8/8] COPY docker/entrypoint.sh ./entrypoint.sh

ARG COMMIT_SHA
ENV COMMIT_SHA=${COMMIT_SHA}

EXPOSE 3000
ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]
