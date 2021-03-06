\name{ref_box}
\alias{ref_box}
\title{Reference box glyph}
\usage{
  ref_box(mapping = NULL, fill = "grey90", color = "white",
    ...)
}
\arguments{
  \item{mapping}{An aesthetic mapping, usually constructed
  with \code{\link[ggplot2]{aes}}.}

  \item{fill}{The color, as a character string, to be used
  as the fill if fill is not specified in the mapping}

  \item{color}{The color, as a character string, to be used
  as the color if color is not specified in the mapping}

  \item{...}{other arguments to be used as parameters in
  the reference box layer}
}
\description{
  ref_box creates a layer of reference boxes to be plotted
  behind a layer of glyphs. Each box spans the full width
  and height of the glyph. Reference boxes make it easier
  to determine the location of an object within a glyph and
  to compare objects across glyphs. Reference boxes can
  also convey information on their own through fill,
  colour, alpha, linetype, and (line) size mappings. By
  default the fill and colour parameters of a reference box
  match the grey and white color scheme of ggplot2 panels
  in \code{\link[ggplot2]{theme_grey}}.
}
\details{
  ref_box is a second order function. It returns a function
  that can be used to create a layer of reference boxes
  with the specified mapping and parameters. The output of
  ref_box is intended to be passed as the reference
  argument for \code{\link{grid}} or \code{\link{glyph}}.
}
\seealso{
  \code{\link{ref_hline}}, \code{\link{ref_vline}} and
  \code{\link{ref_points}}
}

