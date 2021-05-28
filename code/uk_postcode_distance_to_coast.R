# libraries
library(rgdal) 
library(sp) 
library(raster)
library(rgeos)


# change working directory to the directory of the script
try( setwd(dirname(rstudioapi::getActiveDocumentContext()$path)))

# First, get the postcode data from https://www.getthedata.com/downloads/open_postcode_geo.csv.zip
# Unzip into same directory as this R file

# load the CSV, this might take a while
pc <- read.csv("./open_postcode_geo.csv", as.is=TRUE, header=FALSE)
# reduce the data, drop all column but the postcode and the projected coordinates...
pc <- subset(pc, V7 =="England")
pc <- pc[,c(1,8,9)]
colnames(pc) <- c("postcode","lat","lon")
pc$pc_short <- gsub(" .*$", "", pc$postcode, perl=TRUE)
pc$lat <- as.numeric(pc$lat)
pc$lon <- as.numeric(pc$lon)
pc <- subset(pc, !is.na(lat))

# get average lat and lon per short postcode (this is crude)
lat.m <- as.data.frame( tapply(pc$lat, pc$pc_short, mean) )
colnames(lat.m) <- "lat"
lon.m <- as.data.frame( tapply(pc$lon, pc$pc_short, mean) )
colnames(lon.m) <- "lon"
lat.m$pc <- row.names(lat.m)
lon.m$pc <- row.names(lon.m)
coords.m <- merge(lat.m, lon.m, by="pc")
coordinates(coords.m) = ~lon+lat
crs(coords.m) <- CRS("+init=epsg:4326")

# run the next line for a nice map of the UK (will take a long time....)
# plot(pc$lon, pc$lat, pch=19, cex=0.1)

# get a map of UK coastlines... e.g. here: https://osdatahub.os.uk/downloads/open/BoundaryLine
# save high_water_polyline into a folder, e.g. "water" 
coast <- readOGR(dsn="./water/")
crs(coast) <- CRS("+init=epsg:27700")
pc.proj <- spTransform(coords.m, CRS("+init=epsg:27700"))

# testing that the projections are in sync...
plot(pc.proj, col="red", pch=19)
plot(coast, add=TRUE)

# this can take a long long time....
dists <- gDistance(pc.proj, coast, byid=TRUE)
mins <- apply(dists, 2, min)
coords.m$min_distance_coast <- round(mins)

write.csv( as.data.frame(coords.m), file="./dist_to_coast.csv", row.names=FALSE)

