FROM node
RUN npx create-next-app mathjs-test --js --no-eslint --use-npm
WORKDIR mathjs-test
RUN npm i --save complex.js
COPY pages/index.js pages/complex.js pages/
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
