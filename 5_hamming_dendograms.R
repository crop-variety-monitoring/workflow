
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (host == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
#} else if (host == "???") {
#   path <- "c:/mypath"
}
setwd(path)
dir.create("output/img", FALSE, FALSE)

ff <- list.files("input", pattern="2row.csv$", recursive=TRUE, full=TRUE)


for (f in ff) {
	print(f); flush.console()
	x <- matchpoint::read_dart(f)
	genofile <- gsub("SNP_2row.csv$", "variety-info.csv", f)
	g <- data.frame(data.table::fread(genofile))

	ref <- x$snp[, colnames(x$snp) %in% g$sample[g$reference]]
	d <- matchpoint:::hamming_distance(ref)

	h <- hclust(as.dist(d))
	labs <- h$labels[h$order]
	j <- match(labs, gsub("_D.$", "", g$sample))
	variety <- g$variety[j]
	variety2 <- paste0(g$variety[j], " (", g$sample[j], ")")
	set.seed(1)
	rc <- sample(rainbow(length(unique(variety))))
	cols <- rep(NA, length(variety))
	ref <- as.integer(as.factor(variety))
	cols <- rc[ref]
	main <- gsub("_SNP_2row.csv", "", basename(f))
	fname <- gsub("_SNP_2row.csv", "", gsub("input/", "", f))
	fname <- gsub("/", "_", fname)
	fname <- file.path("results/img", paste0(fname, "_ref-ham.png"))
	width <- 250 * round(nrow(d)/10)

	png(fname, width, 1000, pointsize=15)
	par(mar=c(10, 2.5, 2, 1))
	hc = plot(h, hang=-1, main=main, sub="", xlab="", labels=FALSE)
	text((1:length(labs))+.25, rep(0, length(labs)), variety2, col=cols, xpd=T, srt=90, pos=2)
	dev.off()
}

