
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

ff = rev(ff)

for (f in ff) {
	print(f)
	match_field <- c("sample", "target.id")[grepl("ETH", f)+1]	
	snps <- matchpoint::read_dart(f)
	fgeno <- gsub("input", "output/IBS/refine", gsub("_Counts.csv$", "_refine.xlsx", f))
	genotypes <- suppressWarnings(readxl::read_excel(fgeno, sheet="genotypes")) |> data.frame()
	filename <- file.path(gsub("input", "output/CDS/match", dirname(f)), snps$order)
	out <- matchpoint:::match_CDS(snps, genotypes, match_field=match_field, filename=filename)
}

	# x = snps; method = "cor"; snp_mr=0.2; CDS_cutoff=0.5; mincounts=NULL; assign_threshold=NULL; verbose=FALSE; filename=""; sample_mr=.2; snp_mr=.2

