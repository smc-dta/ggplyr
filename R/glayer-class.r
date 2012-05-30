#' @include glyphs-class.r
NULL

check_glayer <- function(object) {
	errors <- character()
	if (!is.proto(object@layer)) {
		msg <- "glayer must be a proto object."
		errors <- c(errors, msg)
	}
	if (length(errors) == 0) 
		TRUE
	else
		errors
}

setOldClass(c("proto", "environment"))

#' glayer class
#'
#' glayers are layers made with ggplyr methods. They are equivalent to the layers made by ggplot2 functions in all ways except that they contain an extra grouping variable (to denote subplot membership) and a plyr_function slot, which correctly locates subplots within the graph when plotting.
#'
#' @name glayer-class
#' @rdname glayer-class
#' @exportClass glayer
#' @aliases show,glayer-method
#' @aliases c,glayer-method
#' @aliases rep,glayer-method
#' @aliases ls,glayer-method
#' @aliases [,glayer-method
#' @aliases [<-,glayer-method
#' @aliases $,glayer-method
#' @aliases $<-,glayer-method
#' @aliases +,ggplot,glayer-method
#' @aliases +,glyphs,glayer-method
#' @aliases ggtransform,glayer-method
setClass("glayer", representation(layer = "proto"), validity = check_glayer)

#' @export
setMethod("show", signature(object = "glayer"), function(object) {
	print(object@layer) 
})

#' @export
setMethod("c", signature(x = "glayer"), function(x, ...){
	# c(get_layer(x), unlist(lapply(list(...), get_layer)))
	stop("object of type 'glayer' is not subsettable")
})

#' @export
setMethod("rep", signature(x = "glayer"), function(x, ...){
	stop("object of type 'glayer' is not subsettable")
})

#' @export
setMethod("[", signature(x = "glayer"), 
	function(x, i, j, ..., drop = TRUE) {
    	new("glayer", layer = x@layer[i])
	}
)

#' @export
setMethod("[<-", signature(x = "glayer"), function(x, i, j, ..., value) {
  	x@layer[i] <- value
	x
})


#' @export
setMethod("$", signature(x = "glayer"), function(x, name) {
	slot(x, "layer")[[name]]
})

#' @export
setMethod("$<-", signature(x = "glayer"), function(x, name, value) {
	slot(x, "layer")[[name]] <- value
	x
})

#' @export
setMethod("+", signature(e1 = "ggplot", e2 = "glayer"), 
	function(e1, e2) {
		glyph_plot(e1 + e2@layer)
	}
)

#' @export
setMethod("+", signature(e1 = "glyphs", e2 = "glayer"), 
	function(e1, e2) {
		glyph_plot(e1@.Data + e2@layer)
	}
)
	
	
#' @export
setMethod("ggtransform", signature(ggobject = "glayer"), 
	function(ggobject, mapping, ...){
		layer <- ggtransform(ggobject@layer, mapping, ...)
		new("glayer", layer = layer)
	}
)

#' @export
setGeneric("ls")

#' @export
setMethod("ls", signature(name = "glayer"), 
	function(name, pos = -1, envir = as.environment(pos), all.names = FALSE, pattern) {
		ls(slot(name, "layer"), all.names)
})
	
#' Create a glayer object
#' 
#' glayer gives a ggplot2 layer object the S4 class glayer, see \code{\link{glayer-class}}. ggplot layer objects are usually non-specific \code{\link{proto}} class objects.
#'
#' @export glayer
#' @param layer a proto object that can be used as a layer by the \code{\link{ggplot2}} package (i.e, ggplot() + layer should return a graph).
glayer <- function(layer) {
	new("glayer", layer = layer)
}