
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
for (dart_file in ff) {
	print(dart_file)
	snps <- matchpoint::read_dart(dart_file)
	genofile <- gsub("SNP.csv$", "variety-info.csv", dart_file)
	genotypes <- data.frame(data.table::fread(genofile))
	filename <- file.path(gsub("input", "output/IBS", dirname(dart_file)), snps$order)
	out <- matchpoint::match_IBS(snps$snp, genotypes, markers, filename=filename, threads=4)
}

#MAF_cutoff=0.05; SNP_Missing_Rate=0.2; Ref_Missing_Rate=0.2; Sample_Missing_Rate=0.2; Ref_Heterozygosity_Rate = 0.1; Sample_Heterozygosity_Rate=0.1; IBS_cutoff=0.5; Inb_method = "mom.visscher"; threads=1; verbose=FALSE; filename=""

