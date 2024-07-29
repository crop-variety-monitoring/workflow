
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
f = ff[4]
filename = ""
pars <- data.frame(
	crop=c("Ri", "Er", "Co", "Mz", "Cp", "Ca"),
	lump=c(.01,  .01,   .01,  .05,  .01,   .01),
	split=c(.05,  .05,   .05,  .15, .05,   .05)
)

ff = rev(ff)

for (f in ff) {
	print(f)
	crop <- substr(basename(f), 2, 3)
	p <- pars[pars$crop == crop, ]
	stopifnot(nrow(p) == 1)
	snps <- matchpoint::read_dart(f)
	genotypes <- gsub("SNP.csv$", "variety-info.csv", f) |> data.table::fread() |> data.frame()	
	filename <- file.path(gsub("input", "output/IBS/refine", dirname(f)), paste0(snps$order, "_refine"))
	match_field <- c("sample", "target.id")[grepl("ETH", f)+1]
	out <- matchpoint::refine_IBS(snps, genotypes, match_field=match_field, markers, ref_split=p$split, ref_lump=p$lump, filename=filename, threads=4, verbose=FALSE)
}

# x = snps; MAF_cutoff=0.05; SNP_Missing_Rate=0.2; Ref_Missing_Rate=0.2; Sample_Missing_Rate=0.2; Ref_Heterozygosity_Rate = 0.1; Sample_Heterozygosity_Rate=0.1; Inb_method = "mom.visscher"; threads=1; verbose=FALSE; filename=""; ref_split=0.1; ref_lump=0.05; match_field="sample"; sample_mr=NULL; snp_mr=NULL

