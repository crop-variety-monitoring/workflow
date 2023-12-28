
path <- "."
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
#} else if (host == "???") {
#   path <- "c:/mypath"
}
setwd(path)

ff <- list.files("output", pattern="xlsx$", recursive=TRUE, full=TRUE)

for (xlfile in ff) {
	print(xlfile); flush.console()

	d <- readxl::read_excel(xlfile, "distance")
	r <- readxl::read_excel(xlfile, "ref")
	
	i <- names(d) %in% r$ref_id
	dr <- d[i[-1],i]
	h <- hclust(as.dist(dr))
	labs <- h$labels[h$order]
#	j <- match(r$ref_id, labs)
	j <- match(labs, r$ref_id)
	variety <- r$variety[j]
	set.seed(1)
	rc <- sample(rainbow(length(unique(variety))))
	cols <- rep(NA, length(variety))
	ref <- as.integer(as.factor(variety))
	cols <- rc[ref]
	main <- gsub("_IBS.xlsx", "", gsub("output/", "", xlfile))
	fname <- gsub("_IBS.xlsx", "", xlfile)
	fname <- paste0(fname, "_ref_ddgram.png")
	png(fname, 3600, 1000, pointsize=15)
	par(mar=c(8,2.5,2,1))
	hc = plot(h, hang=-1, main=main, sub="", xlab="", labels=FALSE)
	text((1:length(labs))+.25, rep(0, length(labs)), variety, col=cols, xpd=T, srt=90, pos=2)
	dev.off()
}
