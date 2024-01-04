
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

ff <- list.files("input", pattern="SNP_2row.csv$", recursive=TRUE, full=TRUE)
dir.create("output/HAM", FALSE, TRUE)

#ff = ff[3]
for (f in ff) {
	print(f)
	snps <- matchpoint::read_dart(f)
	genotypes <- gsub("SNP_2row.csv$", "variety-info.csv", f) |> 
						data.table::fread() |> data.frame()
	filename <- file.path(gsub("input", "output/HAM", dirname(f)), snps$order)
	print(system.time(out <- matchpoint::match_distance(snps, genotypes, missing_rate=0.2, filename=filename)))
}

#x=snps; compare="ref2fld";  missing_rate=0.25;  filename="";  verbose=TRUE
