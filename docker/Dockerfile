FROM node
RUN npx create-next-app danfojs-test --ts --eslint
WORKDIR danfojs-test
RUN npm i --save danfojs
EXPOSE 3000/tcp
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
