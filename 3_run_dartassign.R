
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

	filename <- file.path(gsub("input", "output/IBS", dirname(dart_file)), snps$order)
	out <- matchpoint::match_IBS(snps$snp, genotypes, markers, filename=filename, threads=4)
}

#MAF_cutoff=0.05; SNP_Missing_Rate=0.2; Ref_Missing_Rate=0.2; Sample_Missing_Rate=0.2; Ref_Heterozygosity_Rate = 0.1; Sample_Heterozygosity_Rate=0.1; IBS_cutoff=0.5; Inb_method = "mom.visscher"; threads=1; verbose=FALSE; filename=""

