# next.js local/remote import issue repro

Next.js gets confused by the import:
```javascript
import Complex from "complex.js"
```
when [the `complex.js` NPM package](https://www.npmjs.com/package/complex.js) is present as well as a local file `./complex.js`. The import should resolve to the former, but next.js (or webpack, using next.js's default configs) appears to rewrite it like:

```diff
-import Complex from "complex.js"
+import Complex from "./complex.js"
```

See discussion at [mathjs#2870](https://github.com/josdejong/mathjs/issues/2870), and repro steps below.

## Repro

### Clone this repo
```bash
git clone https://github.com/ryan-williams/next.js-import-bug
cd next.js-import-bug
npm i
```

### Or: create repro from scratch
Create app, install `complex.js`:
```bash
npx create-next-app next.js-import-bug --js --no-eslint --use-npm
cd next.js-import-bug
npm i --save complex.js
```

<details><summary>Create <code>pages/{index,complex}.js</code></summary>

```bash
# Create pages/index.js
cat >pages/index.js <<EOF
import Complex from 'complex.js'

const c = new Complex(11, 22)
if (!!c.props) {
  console.error('`Complex` class refers to a next.js page ❌', c, Complex)
} else if (c.re) {
  console.log("`Complex` class is correct ✅", c, Complex)
} else {
  console.error("`Complex` class not recognized:", c, Complex)
}

export default function Home() {
  return <div>yay</div>
}
EOF

# Create pages/complex.js with the same content
cp pages/{index,complex}.js
```
</details>


## macOS(?): errors due to
Run next.js server:
```bash
PATH="${PATH}:node_modules/.bin"
next dev
```
Open in browser:
```bash
open http://127.0.0.1:3000
```

### Observe warnings

```
./node_modules/mathjs/lib/esm/type/complex/Complex.js
There are multiple modules with names that only differ in casing.
This can lead to unexpected behavior when compiling on a filesystem with other case-semantic.
Use equal casing. Compare these module identifiers:
* javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/type/complex/Complex.js
    Used by 1 module(s), i. e.
    javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/factoriesAny.js
* javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/type/complex/complex.js
    Used by 2 module(s), i. e.
    javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/type/complex/Complex.js
…
./node_modules/mathjs/lib/esm/type/fraction/Fraction.js
There are multiple modules with names that only differ in casing.
This can lead to unexpected behavior when compiling on a filesystem with other case-semantic.
Use equal casing. Compare these module identifiers:
* javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/type/fraction/Fraction.js
    Used by 1 module(s), i. e.
    javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/factoriesAny.js
* javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/type/fraction/fraction.js
    Used by 2 module(s), i. e.
    javascript/esm|/Users/ryan/c/mathjs-test/node_modules/mathjs/lib/esm/type/fraction/Fraction.js
```

### …and corresponding error

```
index.js?46cb:606 Uncaught TypeError: Object.defineProperty called on non-object
    at Function.defineProperty (<anonymous>)
    at createComplexClass.isClass (Complex.js?51b2:11:1)
    at assertAndCreate (factory.js?2286:35:1)
    at eval (pureFunctionsAny.generated.js?b0ab:12:55)
    at ./node_modules/mathjs/lib/esm/entry/pureFunctionsAny.generated.js (index.js?ts=1672683969845:4196:1)
    at options.factory (webpack.js?ts=1672683969845:673:31)
    at __webpack_require__ (webpack.js?ts=1672683969845:37:33)
    at fn (webpack.js?ts=1672683969845:328:21)
    at eval (mainAny.js:11:88)
    at ./node_modules/mathjs/lib/esm/entry/mainAny.js (index.js?ts=1672683969845:4185:1)
    at options.factory (webpack.js?ts=1672683969845:673:31)
    at __webpack_require__ (webpack.js?ts=1672683969845:37:33)
    at fn (webpack.js?ts=1672683969845:328:21)
    at ./node_modules/mathjs/lib/esm/index.js (index.js?ts=1672683969845:10038:75)
    at options.factory (webpack.js?ts=1672683969845:673:31)
    at __webpack_require__ (webpack.js?ts=1672683969845:37:33)
    at fn (webpack.js?ts=1672683969845:328:21)
    at eval (index.js:7:64)
    at ./pages/index.js (index.js?ts=1672683969845:49:1)
    at options.factory (webpack.js?ts=1672683969845:673:31)
    at __webpack_require__ (webpack.js?ts=1672683969845:37:33)
    at fn (webpack.js?ts=1672683969845:328:21)
    at eval (?44d9:5:16)
    at eval (route-loader.js?ea34:211:51)
```

![](./error-screenshot.png)

## Linux/Docker: works as intended
[Dockerfile](Dockerfile):
```Dockerfile
FROM node
RUN npx create-next-app mathjs-test --js --no-eslint --use-npm
WORKDIR mathjs-test
RUN npm i --save mathjs
COPY pages/index.js pages/index.js
EXPOSE 3000/tcp
ENV PATH="${PATH}:node_modules/.bin"
ENTRYPOINT ["next", "dev"]
```

Build, run, open:
```bash
docker build -t mathjs-test .
docker run --rm -d -p 3001:3000 mathjs-test
open http://127.0.0.1:3001
```

Page loads+renders without errors or warnings:

![](./success-screenshot.png)

## Relevant versions
* node v19.3.0
* npm 9.2.0
* mathjs 11.5.0
* next 13.1.1
* macOS 12.1
