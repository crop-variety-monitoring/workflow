
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (grepl("farm.hpc.ucdavis.edu", host)) {
	path <- "."
} else if (host == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
} #else if (host == "???") {
#   path <- "c:/mypath"
#}

setwd(path)

fda <- list.files("output/DAP", pattern=".rds$", recursive=TRUE, full=TRUE)
fxl = gsub(".rds", "", fda) 
fin = gsub("output/DAP", "input", fda)
fin = gsub("_DAP.rds", "_variety-info.csv", fin)

for (i in 1:length(fin)) {
	info <- matchpoint:::assign_info(fin[i])
	x <- readRDS(fda[i])
	matchpoint:::assign_write_excel(x, info, fxl[i])
}

