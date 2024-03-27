
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (grepl("farm.hpc.ucdavis.edu", host)) {
	path <- "."
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
} #else if (host == "???") {
#   path <- "c:/mypath"
#}

setwd(path)
ff <- list.files("input", pattern="_Counts.csv$", recursive=TRUE, full=TRUE)
markers <- matchpoint::marker_positions("")

for (f in ff) {
	print(f)
	cat("\n")
	snps <- matchpoint::read_dart(f)
	fgeno <- file.path("output/reference", gsub("Counts.csv$", "variety-info-refined.csv", basename(f)))
	genotypes <- data.table::fread(fgeno) |> data.frame()
	filename <- file.path(gsub("input", "output/CDS", dirname(f)), snps$order)
	out <- matchpoint::match_CDS(snps, genotypes, markers, filename=filename)
	cat("\n\n")
}

