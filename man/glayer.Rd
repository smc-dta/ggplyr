\name{glayer}
\alias{glayer}
\title{Create a glayer object}
\usage{
  glayer(layer)
}
\arguments{
  \item{layer}{a proto object that can be used as a layer
  by the \code{\link[ggplot2]{ggplot2}} package (i.e,
  ggplot() + layer should return a graph).}
}
\description{
  glayer gives a ggplot2 layer object the S4 class glayer,
  see \code{\link{glayer-class}}. ggplot layer objects are
  usually non-specific \code{\link[proto]{proto}} class
  objects. A layer should contain an embed variable before
  being given the class 'glayer.' See the function bodies
  of \code{\link{glyph}} and \code{\link{grid}} for
  examples.
}

