FROM node
RUN npx create-next-app mathjs-test --js --no-eslint
WORKDIR mathjs-test
RUN yarn add mathjs
COPY pages/index.js pages/index.js
EXPOSE 3000/tcp
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
