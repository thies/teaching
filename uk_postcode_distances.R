# change working directory to the directory of the script
try( setwd(dirname(rstudioapi::getActiveDocumentContext()$path)))

# First, get the postcode data from https://www.getthedata.com/downloads/open_postcode_geo.csv.zip
# Unzip into same directory as this R file

# load the CSV, this might take a while
pc <- read.csv("open_postcode_geo.csv", as.is=TRUE, header=FALSE)
# reduce the data, drop all column but the postcode and the projected coordinates...
pc <- pc[,c(1,4,5)]
colnames(pc) <- c("postcode","lat","lon")
pc$lat <- as.numeric(pc$lat)
pc$lon <- as.numeric(pc$lon)
pc <- subset(pc, !is.na(lat))

# run the next line for a nice map of the UK (will take a long time....)
# plot(pc$lon, pc$lat, pch=19, cex=0.1)


# define function to look for postcodes,
# first reduce sample to minimise distance computations
# then run basic Pythagoras (we can do that since coordinates are projected)
pc.dist <- function(x, pc, distance){
  xx <- subset(pc, postcode==x)
  tmp <- subset(pc, lat < (xx$lat[1]+distance) & lat > (xx$lat[1]-distance) )
  tmp <- subset(tmp, lon < (xx$lon[1]+distance) & lon > (xx$lon[1]-distance) )
  tmp$dist <- ((tmp$lon-xx$lon[1])^2 + (tmp$lat-xx$lat[1])^2 )^0.5
  return(tmp$postcode[tmp$dist < distance])
}

### define vector of postcodes 
x <- c("CB1 3DT","CB3 9EP")

# find nearest postcodes
# distance is in meter
nearest.postcodes <- lapply(x, pc.dist, pc=pc, dist=1000)

# have a look at these postcodes
print(nearest.postcodes)

# now do something with these codes, for instance merge to house transactions
