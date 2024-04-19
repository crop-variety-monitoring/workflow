
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}
setwd(file.path(gitpath, "workflow/RMD"))

dout <- file.path(path, "results/html")
dir.create(dout, FALSE, FALSE)

rmarkdown::render("compare_IBS-DAP.Rmd", "html_document")
file.copy("compare_IBS-DAP.html", file.path(dout, "compare_IBS-DAP.html"), overwrite=TRUE)

rmarkdown::render("compare_IBS-DAP.Rmd", "pdf_document")
file.copy("compare_IBS-DAP.pdf", file.path(dout, "compare_IBS-DAP.pdf"), overwrite=TRUE)


rmarkdown::render("compare_IBS-CDS.Rmd", "html_document")
file.copy("compare_IBS-CDS.html", file.path(dout, "compare_IBS-CDS.html"), overwrite=TRUE)

rmarkdown::render("compare_IBS-CDS.Rmd", "pdf_document")
file.copy("compare_IBS-CDS.pdf", file.path(dout, "compare_IBS-CDS.pdf"), overwrite=TRUE)
