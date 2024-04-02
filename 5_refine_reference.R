
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (grepl("farm.hpc.ucdavis.edu", host)) {
	path <- "."
} else if (host == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
} #else if (host == "???") {
#   path <- "c:/mypath"
#}


for (method in c("IBS", "CDS")) {

	setwd(path)
	dir.create("output/reference", FALSE, FALSE)
	ff <- list.files("output", pattern=paste0(method, ".xlsx$"), recursive=TRUE, full=TRUE)

	#ff = grep("Mz", ff, value=TRUE)

	for (i in 1:length(ff)) {
		
		print(ff[i]); flush.console()
		crop <- substr(basename(ff[i]), 2, 3)
		dirn <- dirname(ff[i])
		country <- substr(dirn, nchar(dirn)-2, nchar(dirn))

		finf <- gsub("output/IBS", "input", gsub("_IBS.xlsx", "_variety-info.csv", ff[i]))
		finf <- gsub("IBS", method, finf)
		
		info <- read.csv(finf)
		rinf <- info[info$reference,]

		dcds <- readxl::read_excel(ff[i], "distance") |> data.frame(check.names=FALSE)
		dcds <- dcds[,-1] |> as.matrix()
		cn <- which(colnames(dcds) %in% rinf$sample)
		dst <- dcds[cn, cn]
		
		dcn <- colnames(dst)
		j <- match(dcn, rinf$sample)
		variety <- rinf$variety[j]
		dimnames(dst) <- list(variety, variety)
		
		if (!all(is.na(rinf$inventory[j]))) {
			add1 <- paste0("  (", rinf$sample[j], " / ", rinf$inventory[j],") ")
		} else {
			add1 <- paste0("  (", rinf$sample[j], ") ")
		}
		
		
		nrst <- matchpoint:::min_dist(dst)
		nslf <- matchpoint:::min_self_dist(dst)
		add2 <- paste0(" [", round(10000 * nrst$value), ", ", 
							round(10000 * nslf$value), "]")
		

	# make dendro with original var names
		dc <- matchpoint::group_dend(dst, add=paste0(add1, add2))
	# split and lump

		pars <- data.frame(
					crop=c("Ri", "Er", "Co", "Mz", "Cp", "Ca"),
					lump=c(.01,  .01,   .01,  .05,  .01,   .01),
				   split=c(.05,  .05,   .05,  .15, .05,   .05)
				)

		p <- pars[pars$crop == crop, ]
	#	mdst=dst; maxlump=p$lump; minsplit=p$split
		splum <- matchpoint:::split_lump(dst, p$lump, p$split) 

	#	splum <- matchpoint:::split_lump(dst, .01, .05) 
			
	# write output
		out <- data.frame(sample=dcn, variety=splum$new) 
		info$origvar <- info$variety
		info$variety <- NULL
		infout <- merge(info, out, by="sample", all.x=TRUE)
		fout <- file.path("output/reference", gsub("_variety-info.csv", "_variety-info-refined_cds.csv", basename(finf)))
	#	write.csv(infout, fout, row.names=FALSE, na="")

	# make plot
		dimnames(dst) <- list(splum$new, splum$new)
		k <- stats::order.dendrogram(dc)	
		var2 <- splum$new[k]
		changed <- variety[k] != var2
		var2[!changed] <- ""
		set.seed(1)
		rc2 <- viridis::turbo(length(unique(var2)))
		ref2 <- as.integer(as.factor(var2))
		cols2 <- rc2[ref2]

		fpdf <- gsub(".csv$", ".pdf", fout)
		pdf(fpdf, height=nrow(rinf)/8)
			par(mar=c(3, 0, 0, 20))
			plot(dendextend::highlight_branches_lwd(dc), horiz=TRUE, nodePar=list(cex=.1), cex=.6, xlim=c(
	0.4, 0))
			pd <- diff(par("usr")[1:2]) * .5 
			text(cbind(pd, 1:length(var2)), labels=var2, col=cols2, pos=4, xpd=TRUE, cex=0.5)
			text(0, length(var2)+2, labels="Original name", pos=4, xpd=TRUE, cex=1)
			text(pd, length(var2)+2, labels="Revised name", pos=4, xpd=TRUE, cex=1)
			text(-pd, length(var2)+2, labels=paste0(country, ", ", crop), xpd=TRUE, cex=1)

			lines(cbind(splum$lump, c(0, length(variety))), col=rgb(1,0,0,0.5), lwd=1)
			text(splum$lump, 0, labels=round(splum$lump, 3), adj=0, xpd=TRUE, cex=.5, col="red")
			lines(cbind(splum$split, c(0, length(variety))), col=rgb(0,0,1,0.5), lwd=2)
			text(splum$split, 0, labels=round(splum$split, 3), adj=1, xpd=TRUE, cex=.5, col="blue")
		dev.off()

	}
}
