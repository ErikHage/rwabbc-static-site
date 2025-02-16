FROM ehage/node-buildtools:16 AS buildStage

ENV TERM=xterm \
    HOME=/srv/package

WORKDIR ${HOME}

COPY ./package.json ${HOME}/package.json
COPY ./package-lock.json ${HOME}/package-lock.json

USER root

RUN cd ${HOME} \
    && npm install --loglevel info \
    && chown -R ${SWUSER} ${HOME}/node_modules

COPY ./lib ${HOME}/lib
COPY ./bin ${HOME}/bin

RUN npm prune --production

USER ${SWUSER}

# Exposed Docker Image
FROM ehage/node-base:16

MAINTAINER Erik Hage <ehage4@gmail.com>
LABEL "Description" = "RWBBC Static Web Server"

USER root

ENV HOME=/srv/package

WORKDIR ${HOME}

RUN mkdir -p ${HOME}/logs \
  && chown -R ${SWUSER}:${SWUSER} ${HOME}/logs

COPY --from=buildStage ${HOME}/node_modules ${HOME}/node_modules
COPY ./package.json ${HOME}/
COPY ./lib ${HOME}/lib

ENV SERVICE_3000_NAME=rwbbc-static-web-server

EXPOSE 3000

USER ${SWUSER}

CMD [ "npm", "start" ]
