FROM node
RUN npx create-next-app mathjs-test --ts --eslint
WORKDIR mathjs-test
RUN npm i --save mathjs
EXPOSE 3000/tcp
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
