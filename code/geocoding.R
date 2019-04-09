library(rjson)
library(RCurl)
api.key <- "<YOUR API CODE HERE>"
api.url <- "https://maps.googleapis.com/maps/api/geocode/json"

# load addresses
addresses <- read.csv("addresses.csv", as.is=TRUE, header=FALSE)

# loop throught the addresses, get lat/lon from Google
coords <- list()
for(addr in addresses[,1]){
  url <- paste( api.url, "?address=", URLencode(addr), "&key=", api.key, sep="")
  print(url)
  tmp <- fromJSON( getURL(url) )
  for(res in tmp$results){
    coords[[ length(coords)+1 ]] <- list( addr, res$geometry$location$lat, res$geometry$location$lng)  
  }
}
results <- do.call(rbind, coords)
colnames(results) <- c("address","lat","lon")

# write file
write.csv(results, file="addresses_lat_lon.csv", row.names=FALSE)
