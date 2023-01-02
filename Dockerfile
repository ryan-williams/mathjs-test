FROM node
RUN npx create-next-app mathjs-test --js --no-eslint --use-npm
WORKDIR mathjs-test
RUN npm i --save mathjs
COPY pages/index.js pages/index.js
EXPOSE 3000/tcp
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
