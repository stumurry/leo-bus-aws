FROM node:10.19.0-alpine3.11

ENV BASEDIR=/app/leo-bus
WORKDIR $BASEDIR/src/

COPY src/package* $BASEDIR/src/
RUN npm install
COPY src/ $BASEDIR/src/
COPY docker/build-test/bluesun-config.json $BASEDIR/src/test/config.json
