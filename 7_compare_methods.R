
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}
setwd(file.path(gitpath, "workflow"))

dout <- file.path(path, "results/html")
dir.create(dout, FALSE, FALSE)

#rmarkdown::render("compare.Rmd", "html_document")
file.copy("compare.html", file.path(dout, "compare_methods.html"), overwrite=TRUE)
