
path <- "."
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
  setwd("D:/Git/IMAGE")
#} else if (host == "???") {
#   path <- "c:/mypath"
}

setwd(path)

ff <- list.files(pattern="IBS.csv$", recursive=TRUE)

for (dart_file in ff) {
	print(dart_file)
	info_file <- gsub("IBS.csv$", "info.csv", dart_file)

	outdir = gsub("input", "output/new_IBS", dirname(dart_file))
	dir.create(outdir, FALSE, TRUE)
	pref = gsub(".csv$", "", basename(dart_file))
			
	out = matchpoint:::dart_IBS(dart_file, info_file, 
		# SNP minor allele frequency >= 0.05
		MAF_cutoff=0.05, 
		# missing rate 0.9 is loose, 0.2 is stringent
		SNP_Missing_Rate=0.2, 
		Ref_Missing_Rate=0.2,
		Sample_Missing_Rate=0.2, 
		# exclude genotypes based on their heterozygosity rate
		Ref_Heterozygosity_Rate = 0.1,
		Sample_Heterozygosity_Rate=0.1,
		IBS_cutoff=0.5,
		outdir = outdir, out_prefix=pref, 
		Inb_method = "mom.visscher",
		cpus=1
	)
}

#MAF_cutoff=0.05; SNP_Missing_Rate=0.2; Ref_Missing_Rate=0.2; Sample_Missing_Rate=0.2; Ref_Heterozygosity_Rate = 0.1; Sample_Heterozygosity_Rate=0.1; IBS_cutoff=0.7; out_prefix=pref; Inb_method = "mom.visscher"; cpus=1; verbose=FALSE
