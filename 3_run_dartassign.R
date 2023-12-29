
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

#f = eth[2]
#do = matchpoint::read_dart(f)
#d = matchpoint:::dart_make_unique_ids(do)
#identical(do, d)
#fout = gsub(".csv", "_fixed.csv", f)
#matchpoint:::write_dart(d, fout)

for (counts_file in ff) {
	ordnr <- strsplit(basename(counts_file), "_")[[1]][1]
	filename <- file.path(gsub("input", "output/DartAssign", dirname(counts_file)), ordnr)
	dir.create(dirname(filename), FALSE, TRUE)
	print(counts_file)

	info.file <- gsub("Counts.csv$", "variety-info.csv", counts_file)
	info <- matchpoint:::assign_info(info.file)

	x <- dartVarietalID::runSampleAnalysis(counts_file, info, pop.size=10)

	saveRDS(x, paste0(filename, ".rds"))
	matchpoint:::assign_write_excel(x, info, filename)
}
