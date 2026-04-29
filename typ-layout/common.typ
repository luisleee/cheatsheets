#import "config.typ": *

#let cheatsheet(..args, body) = {
  let args = args.named()
  let title = args.at("title", default: none)
  let columns = args.at("columns", default: 4)
  let date = args.at("date", default: datetime.today())
  let font-size = args.at("font-size", default: length.default-font-size)

  set document(
    title: title,
    date: date,
    author: ("fa_555", "luisleee"),
  )

  set page(
    paper: "a4",
    margin: length.margin,
    flipped: true,
  )

  set par(
    spacing: length.par-spacing,
    leading: length.line-leading,
    justify: true,
  )

  set text(
    font: fonts.serif,
    size: font-size,
    lang: "zh",
    region: "cn",
    weight: fonts.weight,
    cjk-latin-spacing: auto,
  )
  show regex(
    "[，。．、：；？！”’》）』」】〗〕〉］｝“‘《（『「【〖〔〈［｛]+",
  ): it => it.text.replace("。", "．")

  show strong: set text(font: fonts.sans)
  show std.title: set text(weight: fonts.weight, font: fonts.sans, size: font-size)
  show std.title: it => {
    show: align.with(center)

    strong(text(size: 1.5em, it))

    document.author.join(", ")
    " | "
    date.display("[year] 年 [month] 月 [day] 日")

    block(
      above: .5em,
      below: .5em,
      line(length: 100%, stroke: (thickness: .5pt)),
    )
  }

  show heading: set text(font: fonts.sans, weight: fonts.weight, size: font-size)
  show heading: strong
  show heading.where(level: 1): set text(size: font-size * 1.25)
  show heading: set block(above: length.par-spacing * 1.5, below: length.line-leading)
  show heading.where(level: 1): set block(
    above: length.par-spacing * 1.5,
    below: length.line-leading,
  )
  // show heading

  show math.equation: set text(font: fonts.math, size: font-size)

  set table(
    stroke: (thickness: .25pt),
    align: center + horizon,
    inset: (x: 1em, y: .5em),
  )

  set terms(hanging-indent: 0em)

  // sb typst 为了改个字体要写这么多代码
  show terms: it => {
    let spacing = if terms.spacing == auto {
      if terms.tight {
        par.leading
      } else {
        par.spacing
      }
    } else {
      terms.spacing
    }

    it
      .children
      .map(it => block(
        inset: (left: terms.hanging-indent + terms.indent),
        {
          h(-terms.hanging-indent)
          text(it.term)
          terms.separator
          it.description
        },
      ))
      .join(v(weak: true, spacing))
  }

  show: std.columns.with(columns, gutter: 2em)
  body
}
