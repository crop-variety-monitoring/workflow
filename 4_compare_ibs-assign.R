
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}
setwd(path)


fdart <- list.files("output/DartAssign", pattern="xlsx$", recursive=TRUE, full=TRUE)
fdart <- fdart[!grepl("~", fdart)]
fibs <-  list.files("output/IBS", pattern="xlsx$", recursive=TRUE, full=TRUE)
fibs <- fibs[gsub("_IBS", "", basename(fibs)) %in% basename(fdart)]

#for (i in 1:length(fdart)) {
i=3
fd <- fdart[i]
fi <- fibs[i]
da <- readxl::read_excel(fd, "res_full")
ib <- readxl::read_excel(fi, "IBS")

d <- merge(ib, da, by=c("field_id", "ref_id"))

dd <- d[d$rank.y <= 5, ]
cor(dd$IBS, dd$Probability)
cor(dd$rank.x, dd$rank.y, method = "spearman")


plot(d$IBS, d$Probability, cex=.1)
par(mfrow=c(1, 2))
i <- d$rank.x == 1
boxplot(d$rank.y[i])
j <- d$rank.y == 1
boxplot(d$rank.x[j])


f = "C:/github/brian/IMAGE/data/ibs/Tanzania_Rice_matches.xlsx"
f = "C:/github/brian/IMAGE/data/ibs/Nigeria_Rice_matches.xlsx"

old <- readxl::read_excel(f, "IBS_cutoff_0.7_all_match")
old$field_id = gsub("DRi23-7955_", "", old$field_id)
old$ref_id = gsub("DRi23-7955_", "", old$ref_id)

dd <- merge(ib, old, by=c("field_id", "ref_id"))
plot(IBS.y ~ IBS.x, data=dd, cex=.1)


	
#}
