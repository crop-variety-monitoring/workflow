
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

ff <- list.files("output", pattern="gds$", recursive=TRUE, full=TRUE)
xf <- gsub("geno.gds$", "IBS.xlsx", ff)

for (i in 1:length(ff)) {
	fgds <- ff[i] 
	fxls <- xf[i]
	gds <- SNPRelate::snpgdsOpen(fgds)
	xls <- readxl::read_excel(fxls, "ref")
	useref <- xls$ref_id[!xls$drop_miss]
	ibs <- SNPRelate::snpgdsIBS(gds, sample.id=useref, num.thread=1, autosome.only=FALSE)
	ibs.hc <- SNPRelate::snpgdsHCluster(ibs, hang=0.25)
	rv <- SNPRelate::snpgdsCutTree(ibs.hc, z.threshold=15, n.perm=50000, label.Z=T,  label.H=FALSE, verbose=TRUE)

#	png(fname, 3600, 1000, pointsize=15)
#	par(mar=c(8,2.5,2,1))

	SNPRelate::snpgdsDrawTree(rv, rv$clust.count, leaflab="perpendicular",
		edgePar = list(col=rgb(0.5,0.5,0.5, 0.75), t.col="black", y.cex=0.01))

#	dev.off()
}
