
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

for (f in ff) {
	print(f)
	snps <- matchpoint::read_dart(f)
	genotypes <- gsub("SNP.csv$", "variety-info.csv", f) |> data.table::fread() |> data.frame()
	filename <- file.path(gsub("input", "output/IBS", dirname(f)), snps$order)
	out <- matchpoint::match_IBS(snps, genotypes, markers, filename=filename, threads=4, verbose=TRUE)
	cat("\n\n")
}

#MAF_cutoff=0.05; SNP_Missing_Rate=0.2; Ref_Missing_Rate=0.2; Sample_Missing_Rate=0.2; Ref_Heterozygosity_Rate = 0.1; Sample_Heterozygosity_Rate=0.1; IBS_cutoff=0.5; Inb_method = "mom.visscher"; threads=1; verbose=FALSE; filename=""

