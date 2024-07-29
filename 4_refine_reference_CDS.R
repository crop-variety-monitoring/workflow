
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
ff <- rev(ff)
f = ff[4]
filename = ""
pars <- data.frame(
	crop=c("Ri", "Er", "Co", "Mz", "Cp", "Ca"),
	lump=c(.01,  .01,   .01,  .05,  .01,   .01),
	split=c(.05,  .05,   .05,  .3, .05,   .05)
)


for (f in ff) {
	print(f)
	crop <- substr(basename(f), 2, 3)
	p <- pars[pars$crop == crop, ]
	stopifnot(nrow(p) == 1)
	snps <- matchpoint::read_dart(f)
	genotypes <- gsub("Counts.csv$", "variety-info.csv", f) |> data.table::fread() |> data.frame()	
	filename <- file.path(gsub("input", "output/CDS/refine", dirname(f)), paste0(snps$order, "_refine"))
	match_field <- c("sample", "target.id")[grepl("ETH", f)+1]	
	out <- matchpoint:::refine_CDS(snps, genotypes, match_field=match_field, ref_split=p$split, ref_lump=p$lump, filename=filename)
}


# x = snps; method = "cor"; ref_split=0.1; ref_lump=0.05; snp_mr=0.2; sample_mr=0.2; CDS_cutoff=0.5; mincounts=NULL; assign_threshold=NULL; verbose=FALSE; filename=""

