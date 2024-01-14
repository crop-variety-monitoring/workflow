
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	outpath <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (grepl("farm.hpc.ucdavis.edu", host)) {
	gitpath <- "."
	outpath <- "."
} # else if (host == "???") {
#   gitpath <- "c:/mypath"
#	outpath <- "d:/otherpath"
#}

setwd(gitpath)

nga <- data.frame(country="NGA", get_varinfo("data-NGA/raw/dart/", FALSE))
tza <- data.frame(country="TZA", order=NA, get_varinfo("data-TZA/raw/dart/", FALSE))
eth <- data.frame(country="ETH", order=NA, get_varinfo("data-ETH/raw/dart/", FALSE))

x <- rbind(nga, tza, eth)
x$variety <- fix_varnames(x$variety)
tab <- table(x$variety, x$country)
d <- data.frame(tab[,1], tab[,2], tab[,3])
colnames(d) <- colnames(tab)
i <- rowSums(d>0) > 1
d[i,]


test <- function(vars) {
	nuv <- length(unique(vars))
	uv <- gsub(" ", "", (tolower(unique(vars))))
	uv <- gsub("-", "", uv)
	nuv - length(unique(uv))
}
test(x$variety)


