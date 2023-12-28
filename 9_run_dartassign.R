
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

library(dartVarietalID)
ff <- list.files("input", pattern="Counts.csv$", recursive=TRUE, full=TRUE)
#ff = ff[3]
for (counts_file in ff) {
	print(counts_file)
	info.file <- gsub("Counts.csv$", "variety-info.csv", counts_file)
	info <- matchpoint:::assign_info(info.file)
#	pop.size = 10
#	counts.file = counts_file
#	info.file = info 
	x = dartVarietalID::runSampleAnalysis(counts_file, info)
	ordnr <- strsplit(basename(counts_file), "_")[[1]][1]
	filename <- file.path(gsub("input", "output/DartAssign", dirname(counts_file)), 
		paste0(ordnr, ".rds"))
	saveRDS(x, filename)
}


