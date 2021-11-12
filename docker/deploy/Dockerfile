FROM node:10.19.0-alpine3.11
ENV LEO_CLI_VER=2.6.2
ENV BASEDIR=/app/leo-bus
WORKDIR $BASEDIR/src/
# core requirements
# pulled: {libre/open}ssl-dev
RUN apk add --no-cache vim python3 coreutils \
      bash openssh curl tar jq \
      linux-headers make python3-dev\
      gcc libc-dev libffi-dev groff less git
RUN npm install -g npm@latest
RUN npm install -g leo-cli@$LEO_CLI_VER typescript
RUN pip3 install --upgrade awscli &&\
    npm install encoding
COPY src/package* $BASEDIR/src/
RUN npm install
COPY src/ $BASEDIR/src/