
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (host == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
#} else if (host == "???") {
#   path <- "c:/mypath"
}
setwd(path)

ff <- list.files("output/IBS", pattern="xlsx$", recursive=TRUE, full=TRUE)

for (fxls in ff) {
	print(fxls); flush.console()
	d <- readxl::read_excel(fxls, "distance")
	r <- readxl::read_excel(fxls, "ref")
	i <- names(d) %in% r$ref_id
	dr <- d[i[-1],i]
	h <- hclust(as.dist(dr))
	labs <- h$labels[h$order]
#	j <- match(r$ref_id, labs)
	j <- match(labs, r$ref_id)
	variety <- paste0(r$variety, " (", r$ref_id, ")")[j]
	set.seed(1)
	rc <- sample(rainbow(length(unique(variety))))
	cols <- rep(NA, length(variety))
	ref <- as.integer(as.factor(variety))
	cols <- rc[ref]
	main <- gsub("_IBS.xlsx", "", gsub("output/", "", fxls))
	fname <- gsub("_IBS.xlsx", "", fxls)

	fname <- paste0(fname, "_ref_ddgram.png")
	width <- 250 * round(nrow(dr)/10)

	png(fname, width, 1000, pointsize=15)
	par(mar=c(10, 2.5, 2, 1))
	hc = plot(h, hang=-1, main=main, sub="", xlab="", labels=FALSE)
	text((1:length(labs))+.25, rep(0, length(labs)), variety, col=cols, xpd=T, srt=90, pos=2)
	dev.off()

}




	#fname <- paste0(fname, "_mds.png")
#	png(fname, width, 1000, pointsize=15)
	#m <- cmdscale(as.dist(d[,-1]))
	#m = MASS::isoMDS(as.dist(d[,-1]))$points	
	#i <- rownames(m) %in% r$ref_id
	#plot(m, type="n", xlab="", ylab="")
#	points(m[i,], cex=1, col="red", pch=20)
	#points(m[!i,], cex=.5, col=gray(0, alpha=.6), pch=20)
	#terra::halo(m[i,], label=rownames(m)[i], cex=.5, col="blue")
#	dev.off()
