
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

ff <- list.files("input", pattern="SNP_Counts.csv$", recursive=TRUE, full=TRUE)

counts_file = ff = ff[3]

for (counts_file in ff) {
	print(dart_file)
	info.file <- gsub("SNP_Counts.csv$", "genotype-info.csv", dart_file)


	x = runSampleAnalysis(counts.file, info.file)

	filename <- file.path(gsub("input", "output/DartAssign", dirname(dart_file)), snps$order)
}
