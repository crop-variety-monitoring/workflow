
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	outpath <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (grepl("farm.hpc.ucdavis.edu", host)) {
	gitpath <- "."
	outpath <- "."
} # else if (host == "???") {
#   gitpath <- "c:/mypath"
#	outpath <- "d:/otherpath"
#}

setwd(gitpath)

matchpoint:::prepare_dart("data-NGA/raw/dart/", file.path(outpath, "input/NGA"))
matchpoint:::prepare_dart("data-TZA/raw/dart/", file.path(outpath, "input/TZA"))
matchpoint:::prepare_dart("data-ETH/raw/dart/", file.path(outpath, "input/ETH"))




