
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}

setwd(file.path(gitpath, "workflow"))

dout <- file.path(path, "results/html")

renderRMD <- function(html) {
	if (html) {
		rmarkdown::render(frmd, "html_document", "temp", envir=new.env())
		file.rename(gsub(".Rmd", ".html", frmd), file.path(dout, method, paste0(outf, ".html")))
	} else {
		rmarkdown::render(frmd, "html_document", "temp", envir=new.env())
		file.rename(gsub(".Rmd", ".html", frmd), file.path(dout, method, paste0(outf, ".html")))
		rmarkdown::render(frmd, "pdf_document", "temp", envir=new.env())
		file.rename(gsub(".Rmd", ".pdf", frmd), file.path(dout, method, paste0(outf, ".pdf")))
	}
}


onlyhtml <- FALSE

for (method in c("IBS", "CDS")) {

#method="CDS"

	dir.create(file.path(dout, method), FALSE, TRUE)

	rmd <- readLines("RMD/describe_reference.Rmd")
	rmd <- gsub("IBS", method, rmd)

	ords <- matchpoint:::order_names()
	ords <- ords[rev(order(ords$cc)), ]

	titi <- grep("title: ", rmd)
	ordi <- grep("ordnr <- ", rmd)
	crpi <- grep("crop <- ", rmd)
	cnti <- grep("country <- ", rmd)

	#caci <- grep("docache <-", rmd)
	#rmd[caci] <- "docache <- FALSE"


	for (i in 1:nrow(ords)) {
		print(paste("reference:", ords$cc[i], ords$name[i]))
		rmd[titi] <- paste0("title: ", ords$cc[i])
		rmd[ordi] <- paste0("ordnr <- '", ords$name[i], "'")
		rmd[crpi] <- paste0("crop <- '", ords$crop[i], "'")
		rmd[cnti] <- paste0("country <- '", ords$country[i], "'")
		fpath <- file.path("desc", ords$name[i])
		dir.create(fpath, FALSE, TRUE)
		frmd <- file.path(fpath, "temp.Rmd")
		writeLines(rmd, frmd)
		outf <- paste0(ords$country[i], "_", ords$crop[i], "_reference_", method)
		renderRMD(onlyhtml)
	}
}

