// This should resolve to the `complex.js` NPM package, but
// next.js/webpack rewrites it as "./complex.js"
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
