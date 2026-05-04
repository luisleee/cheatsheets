#let length = (
  default-font-size: 7pt,
  line-leading: .65em,
  par-spacing: .65em,
  margin: 2em,
  inf: 114514em,
)

// @typstyle off
#let fonts = (
  canonical: (
    serif: (
      (name: "New Computer Modern", covers: "latin-in-cjk"),
      "Source Han Serif SC",
      "Noto Serif CJK SC",
    ),
    sans: (
      (name: "New Computer Modern Sans", covers: "latin-in-cjk"),
      "Source Han Sans SC",
      "Noto Sans CJK SC",
    ),
    mono: (
      "New Computer Modern Mono",
      "Source Han Sans SC",
      "Noto Sans CJK SC",
    ),
    math: (
      (name: "Computer Modern Symbol", covers: regex("[𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩-𝒬ℛ𝒮-𝒵]")),
      "New Computer Modern Math",
      "New Computer Modern",
      "Source Han Serif SC",
      "Noto Serif CJK SC",
    ),
    weight: 100,
  ),

  latex-like: (
    serif: (
      (name: "New Computer Modern", covers: "latin-in-cjk"),
      "SimSun",
    ),
    sans: (
      (name: "New Computer Modern", covers: "latin-in-cjk"),
      "SimHei",
    ),
    mono: (
      "New Computer Modern Mono",
      "SimHei",
    ),
    math: (
      (name: "Computer Modern Symbol", covers: regex("[𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩-𝒬ℛ𝒮-𝒵]")),
      "New Computer Modern Math",
      "New Computer Modern",
      "SimSun",
    ),
    weight: 400,
  ),
).at("canonical")
