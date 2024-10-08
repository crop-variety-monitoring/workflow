
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

ff <- list.files("input", pattern="SNP.csv$", recursive=TRUE, full=TRUE)
markers <- matchpoint::marker_positions("")

ff = rev(ff)

for (f in ff) {
	print(f)
	snps <- matchpoint::read_dart(f)
	fgeno <- gsub("input", "output/IBS/refine", f)
	fgeno <- gsub("_SNP.csv$", "_refine_IBS_variety-info.csv", fgeno)
	genotypes <- read.csv(fgeno)
	match_field <- c("sample", "targetID")[grepl("ETH", f)+1]	
	filename <- file.path(gsub("input", "output/IBS/match/", dirname(f)), paste0(snps$order, "_match"))

	out <- matchpoint::match_IBS(snps, genotypes, match_field=match_field, markers, filename=filename, threads=4, verbose=FALSE)
}

# x = snps; MAF_cutoff=0.05; SNP_Missing_Rate=0.2; Ref_Missing_Rate=0.2; Sample_Missing_Rate=0.2; Ref_Heterozygosity_Rate = 0.1; Sample_Heterozygosity_Rate=0.1; IBS_cutoff=0.5; Inb_method = "mom.visscher"; assign_threshold=.9; threads=1; verbose=FALSE; filename=""
