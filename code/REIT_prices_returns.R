# Vector of Ticker simbols for UK REITs and Property companies
# one can get these from SNL.com, for instance
ukreitspropcos <- c("MKLW","AEWL","AEWU","ALPH","ASPL","AGR","ATL","ATRS","BYG","BLND","CNN","CAPC","CAL","CDFF","CRC","CSH","CLI","CIC","CREI","DJAN","DLN","DUPD","EZH","ESP","ERET","FCPT","FCRE","FLK","DIGS","GRI","GPOR","HMSO","HSTN","HLCL","HCFT","IHG","INTU","LAND","LSR","LOK","LAS","LMP","LXB","LXI","MPO","MSP","MCKS","MXF","MLC","MAB","MTVW","NRP","NFP","NRR","PILR","PNS","PCTN","PHP","PRSR","RUS","RDI","RLE","RGL","RESI","SAFE","SREI","SIR","SGRO","SHB","SRE","SMP","SLI","SMTG","SUPR","THRL","TOWN","SOHO","BBOX","UAI","UKCM","UTG","UANC","WHR","WKP","WSP","YATRA")

ftse100 <- c("ABF","ADM","AAL","ANTO","AHT","AZN","AV","BAB","BA","BARC","BDEV","BLT","BP","BATS","BLND","BT","BNZL","BRBY","CPI","CCL","CNA","CCH","CPG","CTEC","CRH","CRDA","DCC","DGE","DLG","DC","EZJ","EXPN","FRES","GKN","GSK","GLEN","HMSO","HL","HIK","HSBA","IMB","INF","IHG","ITRK","IAG","INTU","ITV","JMAT","KGF","LAND","LGEN","LLOY","LSE","MKS","MDC","MERL","MCRO","MNDI","MRW","NG","NXT","OML","PPB","PSON","PSN","PFG","PRU","RRS","RDSA","RDSB","RB","REL","RIO","RR","RBS","RMG","RSA","SGE","SBRY","SDR","SVT","SHP","SKY","SN","SMIN","SKG","SSE","STJ","STAN","SL","TW","TSCO","TUI","ULVR","UU","VOD","WTB","WOS","WPG","WPP")

library("quantmod")

mret <- list()
wret <- list()
qret <- list()
allPrices <- list()

for( ticker in ftse100){
  print(ticker)
  # add an .L for London to ticker
  #ticker <- paste(ticker, ".L", sep="")
  try( getSymbols(ticker ,src="google", from="1980-01-01")) # from google finance 
  try( allPrices[[ ticker ]] <- get( ticker ))
  try( mret[[ ticker ]] <- monthlyReturn( get( ticker )))
  try( wret[[ ticker ]] <- weeklyReturn( get( ticker )))
  try( qret[[ ticker ]] <- quarterlyReturn( get( ticker )))
}

monthly <- as.data.frame( do.call( cbind, mret) )
colnames(monthly) <- gsub(".L$", "", names( mret ), perl=TRUE)
monthly$month <- format(as.Date(row.names( monthly)), format="%Ym%m" )
monthly$month <- gsub("m0","m",monthly$month)

quarterly <- do.call( cbind, qret)
colnames(quarterly) <- gsub(".L$", "", names( qret ), perl=TRUE)
 

