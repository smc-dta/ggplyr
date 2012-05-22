# ggplyr features demo - sift for tests

# setwd("/Users/GarrettsiMac/Dropbox/research")
# setwd("/Users/garrettgrolemund/Dropbox/research")
library(devtools)
load_all("ggplyr")

#######################################
###       transform a graph         ###
#######################################

# make a graph
head(test.data)
(p <- qplot(Fertility, Agriculture, data = test.data, color = Education))

# change mappings
ggtransform(p, mapping = aes(size = Catholic))

# nullify mappings, change axis
ggtransform(p, mapping = aes(y = Education, color = NULL, size = Catholic))

# change parameter
ggtransform(p, mapping = aes(y = Education, color = NULL, size = Catholic), shape = 15)




#########################################################
###       use plyr to make groupwise mappings         ###
#########################################################

# Our data is (arbitrarily) grouped into four locations
qplot(Fertility, Agriculture, data = test.data, color = interaction(lat, long))

# use plyr to create a graph
# the aesthetics can be calculated groupwise
ggplot() + geom_plyr(aes(x = Fertility, y = Agriculture, color = rank(Fertility)), test.data, c("lat", "long"), geom = "point", size = 3)

data <- group_by(test.data, c("lat", "long"))
lapply(data, fun(qplot, "data", x = Fertility, y = Agriculture, color = rank(Education), size = I(3), xlim = range(test.data$Fertility), ylim = range(test.data$Agriculture)))

ggplot() + geom_plyr(aes(x = trans, fill = mean(hwy), group = year), mpg, "year", geom = "bar", position = "dodge")

# compare with	
ggplot() + geom_bar(aes(x = trans, fill = mean(hwy), group = year), data = mpg, position = "dodge")



################################################
###       use plyr to embed subplots         ###
################################################
qplot(Fertility, Education, data = test.data, size = I(3))

# relocate data and add within group aes
# MISSING LEGEND
dgply(test.data,
	.split = c("lat", "long"),
	.apply = fun(geom_point, "data", mapping = aes(x = Fertility, y = Education, color = rank(Catholic)), size = 3),
	.combine = fun(nest, "data", major_aes = aes(x = mean(Fertility), 
		y = mean(Education)), width = 5, height = 5))

dgply(test.data, c("lat", "long"),
	fun(geom_point, "data", 
		mapping = aes(x = Fertility, y = Education, color = rank(Catholic)), 
		size = 3),
	fun(nest, "layers", 
		mapping = aes(x = mean(Fertility), y = mean(Education)), 
		width = 5, height = 5))


# adjusting for overlaps etc - separate step modifying the pos_major data frame
# drawing in polar coordinates: adjusting pos_minor, converting from cartesian to polar
#   (won't work for all geoms, but that's ok - will work for lines and points at least)
dgply2 <- function(data, vars, geom, minor, major, ...) {
	browser()
	data$.gid <- id(data[vars])
	
	pos_major <- ddply(data, ".gid", function(df) {
		data.frame(x = eval(major$x, df), y = eval(major$y, df))
	})

	geom <- match.fun(paste("geom_", geom, sep = ""))
	minor$.gid <- quote(.gid)
	plot <- ggplot_build(ggplot(data) + 
		geom(minor) + 
		facet_wrap(".gid"))
		
	
	
	combo <- join(plot$data[[1]], globalize(pos_major), by = ".gid")
	plot$data[[1]][c(".gid", "x", "y")] <- ddply(combo, ".gid", summarize, x = (x - mean(x)) / var(x) + X, y = (y - mean(y)) / var(y) + Y)
	plot$data[[1]]$PANEL <- 1L
	
	plot$plot$facet <- facet_null()
	grid.draw(ggplot_gtable(plot))

}
# does work for points, but no plot history is retained and the x and y axis retain minor names
# need to reset panel ranges to see data for histogram case



# Specific examples
# * glyph type: {point, line, bar, density, histogram} x {cartesian, polar}
# * glyph position: spatial location, temporal location, arbitrary summary
# * glyph position adjustment: various overlapping adjustments
# * embedding: over all layers, over specific layer
# * unique, rounded/binning

# How do we do them currently?
# What should the syntax look like? 
#  embedded_layer(
#    geom_point(aes(Education, Fertility)), 
#    grid(c("lat", "long"), width = 5, height = 5)) ?
# How should it be implemented? 



# * time series of spatial
# * scatterplot plot of spatial
# * scatterplot with arbitrary summaries used for x and y position
# * cleveland cycle plot 
# * polar glyphs
# * bar charts
# * embedded polar bar charts
# * density plots
# * histograms

dgply2(test.data, c("lat", "long"), geom = "point", 
	minor = aes(Fertility, Education, colour = Agriculture),
	major = aes(mean(Fertility), mean(Education)), 
	width = 5, height = 5)

dgply2(test.data, c("lat", "long"), geom = "histogram", 
	minor = aes(Fertility),
	major = aes(mean(Fertility), mean(Education)), 
	width = 5, height = 5)

dgply2(test.data, c("lat", "long"), geom = "histogram", 
	minor = aes(Fertility),
	major = aes(mean(Fertility), mean(Education)), 
	width = 5, height = 5)




# NOT WORKING - smooth won't work on majors that only give back one value per group
# relocate data and add across group aes
dgply(test.data,
	.split = c("lat", "long"),
	.apply = fun(geom_smooth, "data", mapping = aes(x = Fertility, y = Education), method = "lm", se = F),
	.combine = fun(nest, "layers", mapping = aes(x = mean(Fertility), 
		y = mean(Education), color = interaction(long, lat)[1])))


# big data		
qplot(surftemp, temperature, data = nasa)

dgply(nasa,
	.split = c("lat", "long"),
	.apply = fun(geom_point, "data", mapping = aes(x = surftemp, y = temperature), 
		size = 1/5),
	.combine = fun(nest, "layers", mapping = aes(x = long, 
		y = lat), width = 3, height = 3),
	.progress = "text")

qplot(surftemp, temperature, data = nasa, geom = "smooth")

# NOT WORKING
dgply(nasa,
	.split = c("lat", "long"),
	.apply = fun(geom_smooth, "data", mapping = aes(x = surftemp, y = temperature), 
		se = F),
	.combine = fun(nest, "layers", mapping = aes(x = long, 
		y = lat), se = F, x_scale = rescale01, y_scale = rescale01, 
		width = 1, height = 1),
	.progress = "text")

		
dgply(nasa,
	.split = c("lat", "long"),
	.apply = fun(geom_point, "data", mapping = aes(x = 1, y = 1)),
	.combine = fun(nest, "layers", mapping = aes(x = mean(pressure), 
		y = mean(ozone), color = interaction(long[1], lat[1])), width = 3, height = 3),
	.progress = "text")
		
		
		
# nest on just one axiis - NOT WORKING
dgply(test.data,
	.split = c("lat", "long"),
	.apply = fun(geom_point, "data", mapping = aes(x = Fertility, y = Education), 
		size = 3),
	.combine = fun(nest, "layers", mapping = aes(x = mean(Fertility), color = rank(Catholic))))	
# needs fixed




# now with bars
qplot(trans, data = mpg, geom = "bar", fill = year, group = year, position = "dodge")

# NOT WORKING
dgply(mpg,
	.split = c("year"),
	.apply = fun(geom_bar, "data", mapping = aes(x = trans, fill = year)),
	.combine = fun(nest, "layers", mapping = aes(x = mean(hwy), y = mean(cty)), position = "dodge"))
		
		
##################################################
###         recreating model glyphs            ###
##################################################

lgply(m1,
	.apply = fun(geom_point, "data", mapping = aes(x = long[1], y = lat[1])),
	.combine = fun(nest, "layers", mapping = aes(x = mean(temperature), 
		y = mean(surftemp), 
		color = max(surftemp - temperature) == max(abs(surftemp - temperature)))
	)
)



#########################################################
###               testing embed_layers                ###
#########################################################
# goal: return a layer that has a subplots attribute which 
# contains subplot x and y positions by .gid

splits <- group_by(test.data, c("lat", "long"))
layers <- llply(splits, fun(geom_histogram, "data", mapping = aes(x = Fertility, fill = long)))
elayer <- embed_layers(layers, fun(cross, "data", major_aes = aes(x = mean(Fertility), y = mean(Fertility)), width = rel(3), height = rel(1)))
eplot <- gglayer_build(elayer)
gshow(eplot)
eplot
gshow(eplot)
gshow <- function(data, newpage = is.null(vp), vp = NULL, ...){
    if (newpage) 
        grid.newpage()
    gtable <- ggplot_gtable(data)
    if (is.null(vp)) {
        grid.draw(gtable)
    }
    else {
        if (is.character(vp)) 
            seekViewport(vp)
        else pushViewport(vp)
        grid.draw(gtable)
        upViewport()
    }
    invisible(data)
}
gshow(eplot)
layers2 <- llply(splits, fun(geom_point, "data", mapping = aes(x = Fertility, y = long, color = lat)))
elayers2 <- embed_layers(layers2, fun(cross, "data", major_aes = aes(x = mean(Fertility), y = mean(Education))))
eplot2 <- gglayer_build(elayers2)
gshow(eplot2)
p <- nest(layers, mapping = aes(x = mean(Fertility), y = mean(Education)))