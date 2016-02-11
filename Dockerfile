FROM takipone/armhf-alpine-gosu-node:latest

RUN adduser -h /home/user -D user

ENV GHOST_SOURCE /usr/src/ghost
WORKDIR $GHOST_SOURCE

ENV GHOST_VERSION 0.7.6

COPY express.patch ./express.patch

RUN apk --update add --virtual build-dependencies curl gcc g++ musl-dev make patch python unzip \
	&& set -x \
	&& curl -sSL "https://ghost.org/archives/ghost-${GHOST_VERSION}.zip" -o ghost.zip \
	&& unzip ghost.zip \
	&& npm install --production \
  && patch -p 1 < express.patch \
  && apk del build-dependencies \
	&& rm ghost.zip \
	&& npm cache clean \
	&& rm -rf /tmp/npm*

VOLUME $GHOST_SOURCE

EXPOSE 2368
CMD ["npm", "start", "--production"]
