
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

setwd(path)

ff <- list.files("input", pattern="Counts.csv$", recursive=TRUE, full=TRUE)
# skip teff for now. 
#ff <- ff[!grepl("DEra22-7523", ff)]

ff = ff[2]

for (counts.file in ff) {
	ordnr <- gsub("_Counts.csv", "", basename(counts.file))
	filename <- file.path(gsub("input", "output/DAP", counts.file))
	filename <- gsub("_Counts.csv$", "_DAP", filename)
	print(filename)

#	if (file.exists(paste0(filename, ".rds"))) next
	dir.create(dirname(filename), FALSE, TRUE)

	info.file <- gsub("Counts.csv$", "variety-info.csv", counts.file)
	info <- matchpoint:::DAP_info(info.file)
	tmpfile <- paste0(tempfile(), ".csv")
	write.csv(info, tmpfile, na="")

	x <- dartVarietalID::runSampleAnalysis(counts.file,
                         info.file = tmpfile,
                         ncores = parallel::detectCores() - 1,
                         pop.size = 10,
                         dis.mat = TRUE,
                         na.perc.threshold = 50)


	saveRDS(x, paste0(filename, ".rds"))
	matchpoint:::DAP_write_excel(x, info, filename)
}

