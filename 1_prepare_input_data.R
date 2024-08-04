
host <- system("hostname", TRUE)
if (host == "LAPTOP-IVSPBGCA") { 
	gitp <- "c:/github/cropvarmon"
	outp <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (grepl("farm.hpc.ucdavis.edu", host)) {
	gitp <- "."
	outp <- "."
}  else if (host == "???") {
   gitpath <- "c:/mypath"
	outpath <- "d:/otherpath"
}

setwd(gitp)

path <- "data-ETH/raw/dart/"; outpath= file.path(outp, "input/ETH")

matchpoint:::prepare_dart("data-ETH/raw/dart/", file.path(outp, "input/ETH"))

matchpoint:::prepare_dart("data-NGA/raw/dart/", file.path(outp, "input/NGA"))
matchpoint:::prepare_dart("data-TZA/raw/dart/", file.path(outp, "input/TZA"))



