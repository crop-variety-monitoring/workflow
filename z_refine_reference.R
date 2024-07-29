
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

	pars <- data.frame(
		crop=c("Ri", "Er", "Co", "Mz", "Cp", "Ca"),
		lump=c(.01,  .01,   .01,  .05,  .01,   .01),
		split=c(.05,  .05,   .05,  .15, .05,   .05)
	)

	#ff = grep("Mz", ff, value=TRUE)

	for (i in 1:length(ff)) {
		
		print(ff[i]); flush.console()
		crop <- substr(basename(ff[i]), 2, 3)
		dirn <- dirname(ff[i])
		country <- substr(dirn, nchar(dirn)-2, nchar(dirn))

		finf <- gsub("output/...", "input", gsub("_....xlsx", "_variety-info.csv", ff[i]))
		
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

		p <- pars[pars$crop == crop, ]
	#	mdst=dst; maxlump=p$lump; minsplit=p$split
		splum <- matchpoint:::split_lump(dst, p$lump, p$split) 

	#	splum <- matchpoint:::split_lump(dst, .01, .05) 
			
	# write output
		out <- data.frame(sample=dcn, variety=splum$new) 
		info$origvar <- info$variety
		info$variety <- NULL
		infout <- merge(info, out, by="sample", all.x=TRUE)
		fout <- file.path("output/reference", gsub("_variety-info.csv", 
				paste0("_variety-info-refined_", method, ".csv"), basename(finf)))
		write.csv(infout, fout, row.names=FALSE, na="")



		# make plot
		dimnames(dst) <- list(splum$new, splum$new)
		pun <- matchpoint:::punity(dst, seq(0, 0.5, .01))
		i <- nrow(pun) - which.max(rev(pun[,"mean"])) + 1
		v <- matchpoint::self_dist(dst)
		nn <- matchpoint::nngb_dist(dst)$value
		qnn <- quantile(nn, c(0, .05, .1))
		out <- data.frame(
			threshold = pun[i, 1],
			max_same_dist = max(v$value),  
			min_other_dist=t(qnn)
		)
		fstat <- file.path("output/reference", gsub("_variety-info.csv", 
				paste0("_stats_", method, ".csv"), basename(finf)))
		write.csv(round(out, 4), fstat, row.names=FALSE)


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
		plot(dendextend::highlight_branches_lwd(dc), horiz=TRUE, nodePar=list(cex=.1), cex=.6, xlim=c(0.4, 0))
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
	pat <- paste0("_stats_", method, ".csv$")
	fstats <- list.files(path = "output/reference", pattern=pat, full.names=TRUE)
	s <- data.frame(order=gsub(pat, "", basename(fstats)), do.call(rbind, lapply(fstats, read.csv)))
	write.csv(s, paste0("output/reference/stats_", method, ".csv"), row.names=FALSE)
}



f <- function(pars, ds) {
	if (pars[2] > max(ds)) return(Inf)
	if (pars[2] >= pars[1]) return(Inf)
	if (pars[2] < 0) return(Inf)
	splum <- matchpoint:::split_lump(ds, pars[1], pars[2]) 
	dimnames(ds) <- list(splum$new, splum$new)
	y <- matchpoint:::punity(ds, seq(0, 0.5, .01))
	1- max(y[,4])
}	
#f(c(.15, .05), dst)
#optim(c(.15, .05), f, dst)

