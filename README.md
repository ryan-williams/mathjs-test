# danfojs / mathjs issue repro

When `mathjs` is bundled in next.js, there are warnings about conflicting `Complex.js`/`complex.js` and `Fraction.js`/`fraction.js` files.

These seem to lead to an error:
```
Uncaught TypeError: Cannot read properties of undefined (reading 'prototype')
```
and the app doesn't load.

## Setup

### Create app, install danfojs:

```bash
npx create-next-app danfojs-test --ts --eslint
cd danfojs-test
npm i --save danfojs
PATH="${PATH}:node_modules/.bin"
next dev
```

### Create a `dfd.DataFrame` in [pages/index.js](pages/index.js):
```diff
+import * as dfd from "danfojs";
 
 export default function Home() {
+  const df = new dfd.DataFrame([{a:1, b:2}])
   return (
     <div className={styles.container}>
```

## macOS: errors due to case-insensitive filesystem collision in mathjs
Run next.js server:
```bash
next dev
```
Open in browser:
```bash
open http://127.0.0.1:3000
```

<details><summary>Observe warnings</summary>

```
warn  - ./node_modules/mathjs/lib/cjs/type/complex/Complex.js
There are multiple modules with names that only differ in casing.
This can lead to unexpected behavior when compiling on a filesystem with other case-semantic.
Use equal casing. Compare these module identifiers:
* javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/type/complex/Complex.js
    Used by 1 module(s), i. e.
    javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/factoriesAny.js
* javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/type/complex/complex.js
    Used by 2 module(s), i. e.
    javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/type/complex/Complex.js

./node_modules/mathjs/lib/cjs/type/fraction/Fraction.js
There are multiple modules with names that only differ in casing.
This can lead to unexpected behavior when compiling on a filesystem with other case-semantic.
Use equal casing. Compare these module identifiers:
* javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/type/fraction/Fraction.js
    Used by 1 module(s), i. e.
    javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/factoriesAny.js
* javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/type/fraction/fraction.js
    Used by 2 module(s), i. e.
    javascript/dynamic|/Users/ryan/c/danfo-test/node_modules/mathjs/lib/cjs/type/fraction/Fraction.js
```
</details>

<details><summary>and errors</summary>

```
index.js?46cb:606 Uncaught TypeError: Cannot read properties of undefined (reading 'prototype')
    at createComplexClass.isClass (Complex.js?6613:26:1)
    at assertAndCreate (factory.js?0eef:49:1)
    at eval (pureFunctionsAny.generated.js?8847:20:1)
    at ./node_modules/mathjs/lib/cjs/entry/pureFunctionsAny.generated.js (index.js?ts=1672677094234:18720:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (mainAny.js?70c9:53:34)
    at ./node_modules/mathjs/lib/cjs/entry/mainAny.js (index.js?ts=1672677094234:18709:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (index.js?7fe5:7:16)
    at ./node_modules/mathjs/lib/cjs/index.js (index.js?ts=1672677094234:24198:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (frame.js?b00a:92:16)
    at ./node_modules/danfojs/dist/danfojs-base/core/frame.js (index.js?ts=1672677094234:13424:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (dummy.encoder.js?0efd:40:31)
    at ./node_modules/danfojs/dist/danfojs-base/transformers/encoders/dummy.encoder.js (index.js?ts=1672677094234:13732:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (series.js?82be:91:39)
    at ./node_modules/danfojs/dist/danfojs-base/core/series.js (index.js?ts=1672677094234:13468:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (index.js?17c1:46:32)
    at ./node_modules/danfojs/dist/danfojs-base/index.js (index.js?ts=1672677094234:13490:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (index.js?2931:21:22)
    at ./node_modules/danfojs/dist/danfojs-browser/src/index.js (index.js?ts=1672677094234:13820:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (index.js:13:65)
    at ./pages/index.js (index.js?ts=1672677094234:14021:1)
    at options.factory (webpack.js?ts=1672677094234:673:31)
    at __webpack_require__ (webpack.js?ts=1672677094234:37:33)
    at fn (webpack.js?ts=1672677094234:328:21)
    at eval (?2275:5:16)
    at eval (route-loader.js?ea34:211:51)
createComplexClass.isClass @ Complex.js?6613:26
assertAndCreate @ factory.js?0eef:49
eval @ pureFunctionsAny.generated.js?8847:20
./node_modules/mathjs/lib/cjs/entry/pureFunctionsAny.generated.js @ index.js?ts=1672677094234:18720
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ mainAny.js?70c9:53
./node_modules/mathjs/lib/cjs/entry/mainAny.js @ index.js?ts=1672677094234:18709
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ index.js?7fe5:7
./node_modules/mathjs/lib/cjs/index.js @ index.js?ts=1672677094234:24198
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ frame.js?b00a:92
./node_modules/danfojs/dist/danfojs-base/core/frame.js @ index.js?ts=1672677094234:13424
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ dummy.encoder.js?0efd:40
./node_modules/danfojs/dist/danfojs-base/transformers/encoders/dummy.encoder.js @ index.js?ts=1672677094234:13732
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ series.js?82be:91
./node_modules/danfojs/dist/danfojs-base/core/series.js @ index.js?ts=1672677094234:13468
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ index.js?17c1:46
./node_modules/danfojs/dist/danfojs-base/index.js @ index.js?ts=1672677094234:13490
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ index.js?2931:21
./node_modules/danfojs/dist/danfojs-browser/src/index.js @ index.js?ts=1672677094234:13820
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ index.js:13
./pages/index.js @ index.js?ts=1672677094234:14021
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
fn @ webpack.js?ts=1672677094234:328
eval @ ?2275:5
eval @ route-loader.js?ea34:211
setTimeout (async)
eval @ index.js?46cb:605
asyncGeneratorStep @ _async_to_generator.js?0e30:13
_next @ _async_to_generator.js?0e30:31
Promise.then (async)
asyncGeneratorStep @ _async_to_generator.js?0e30:22
_next @ _async_to_generator.js?0e30:31
Promise.then (async)
asyncGeneratorStep @ _async_to_generator.js?0e30:22
_next @ _async_to_generator.js?0e30:31
eval @ _async_to_generator.js?0e30:36
eval @ _async_to_generator.js?0e30:28
_hydrate @ index.js?46cb:645
hydrate @ index.js?46cb:532
eval @ next-dev.js?3515:40
Promise.then (async)
eval @ next-dev.js?3515:35
./node_modules/next/dist/client/next-dev.js @ main.js?ts=1672677094234:236
options.factory @ webpack.js?ts=1672677094234:673
__webpack_require__ @ webpack.js?ts=1672677094234:37
__webpack_exec__ @ main.js?ts=1672677094234:1082
(anonymous) @ main.js?ts=1672677094234:1083
webpackJsonpCallback @ webpack.js?ts=1672677094234:1221
(anonymous) @ main.js?ts=1672677094234:9
```
</details>

![](./error-screenshot.png)

## Linux/Docker: works as intended
[docker/Dockerfile](docker/Dockerfile):
```Dockerfile
FROM node
RUN npx create-next-app danfojs-test --ts --eslint
WORKDIR danfojs-test
RUN npm i --save danfojs
EXPOSE 3000/tcp
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
```

Build, run, open:
```bash
docker build -t danfo-test docker
docker run --rm -p -d 3000:3000 danfo-test
open http://127.0.0.1:3000
```

Page loads+renders without errors or warnings:

![](./success-screenshot.png)
