
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}
setwd(file.path(gitpath, "workflow"))

dout <- file.path(path, "results/html")
dir.create(dout, FALSE, TRUE)

rmd <- readLines("describe.Rmd")
ords <- matchpoint:::order_names()

titi <- grep("title: ", rmd)
ordi <- grep("order <- ", rmd)
crpi <- grep("crop <- ", rmd)
cnti <- grep("country <- ", rmd)

for (i in 1:nrow(ords)) {
	print(ords$cc[i])
	outf <- paste0(ords$country[i], "_", ords$crop[i], ".html")
	rmd[titi] <- paste0("title: ", ords$cc[i])
	rmd[ordi] <- paste0("order <- '", ords$name[i], "'")
	rmd[crpi] <- paste0("crop <- '", ords$crop[i], "'")
	rmd[cnti] <- paste0("country <- '", ords$country[i], "'")
	writeLines(rmd, "temp.Rmd")
	rmarkdown::render("temp.Rmd", "html_document", "temp.html", envir=new.env())
	file.rename("temp.html", file.path(dout, outf))
}

file.remove("temp.Rmd")
