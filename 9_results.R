
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}
setwd(file.path(gitpath, "workflow"))
dout <- file.path(path, "results/html")

for (method in c("IBS", "CDS", "DAP")) {

	dir.create(file.path(dout, method), FALSE, TRUE)

	if (method == "DAP") {
		rmd <- readLines("RMD/results_DAP.Rmd")
	} else {
		rmd <- readLines("RMD/results.Rmd")
		rmd <- gsub("IBS", method, rmd)
	}
	
	ords <- matchpoint:::order_names()
	ords <- ords[rev(order(ords$cc)), ]
	titi <- grep("title: ", rmd)
	ordi <- grep("ordnr <- ", rmd)
	crpi <- grep("crop <- ", rmd)
	cnti <- grep("country <- ", rmd)

	#caci <- grep("docache <-", rmd)
	#rmd[caci] <- "docache <- FALSE"

	dohtml <- TRUE
	for (i in 1:nrow(ords)) {
		print(ords$cc[i])
		print(ords$name[i])
		rmd[titi] <- paste0("title: ", ords$cc[i])
		rmd[ordi] <- paste0("ordnr <- '", ords$name[i], "'")
		rmd[crpi] <- paste0("crop <- '", ords$crop[i], "'")
		rmd[cnti] <- paste0("country <- '", ords$country[i], "'")
		fpath <- file.path("results", ords$name[i])
		dir.create(fpath, FALSE, TRUE)
		frmd <- file.path(fpath, "temp.Rmd")
		writeLines(rmd, frmd)
		outf <- paste0(ords$country[i], "_", ords$crop[i], "_results_", method)

		if (dohtml) {
			rmarkdown::render(frmd, "html_document", "temp", envir=new.env())
			file.rename(gsub(".Rmd", ".html", frmd), file.path(dout, method, paste0(outf, ".html")))
		} else {
			rmarkdown::render(frmd, "pdf_document", "temp", envir=new.env())
			file.rename(gsub(".Rmd", ".pdf", frmd), file.path(dout, method, paste0(outf, ".pdf")))
		}
	}
}
