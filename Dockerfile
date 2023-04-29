FROM node:14-alpine as build

ARG USER=node
WORKDIR /app

COPY --chown=$USER:$USER package*.json .
COPY --chown=$USER:$USER index.js .
COPY --chown=$USER:$USER my-app my-app

# RUN npm install --production && \
#     npm install -g @angular/cli && \
#     cd my-app && \
#     ng build
RUN npm install --production
RUN npm install -g @angular/cli 
RUN cd my-app
RUN npm build

FROM node:14-alpine

ARG USER=node
WORKDIR /app

COPY --from=build --chown=$USER:$USER /app/package.json .
COPY --from=build --chown=$USER:$USER /app/index.js ./
COPY --from=build --chown=$USER:$USER /app/node_modules node_modules
COPY --from=build --chown=$USER:$USER /app/my-app/dist my-app/dist

USER $USER

EXPOSE 3000

CMD ["npm","start"]
# CMD ["sleep","1d"]

# USER root


