#import "@preview/physica:0.9.8": *

#let ee = $upright(e)$
#let ii = $upright(i)$
#let jj = $upright(j)$

#let hfrac = math.frac.with(style: "horizontal")

#let num(n) = $#n$
#let unit(u) = {
  set math.frac(style: "horizontal")
  $upright(#u)$
}
#let qty(n, u) = $#n thin unit(#u)$
