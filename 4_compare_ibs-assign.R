
this <- system("hostname", TRUE)
if (this == "LAPTOP-IVSPBGCA") { 
	gitpath <- "c:/github/cropvarmon"
	path <- "G:/.shortcut-targets-by-id/1mfeEftF_LgRcxOT98CBIaBbYN4ZHkBr_/share/image"
} else if (this == "DESKTOP-M2BA7AA") {
	path <- "google drive path"
}

setwd(file.path(gitpath, "workflow"))

dout <- file.path(path, "compare_methods")
dir.create(dout, FALSE, FALSE)

knitr::knit("compare.Rmd")
file.copy(file.path(drmd, "compare.html"), file.path(dout, "compare.html"), overwrite=TRUE)



fdart <- list.files("output/DAP", pattern="xlsx$", recursive=TRUE, full=TRUE)
fdart <- fdart[!grepl("~", fdart)]
fibs <- gsub("DAP", "IBS", fdart)

#for (i in 1:length(fdart)) {
i=2
fi <- fibs[i]
fd <- fdart[i]

ib <- readxl::read_excel(fi, "IBS_variety") |> data.frame()
da <- readxl::read_excel(fd, "res_full") |> data.frame()

# remove cases where all (or very many) are ranked 1
tab <- table(da$field_id[da$var_rank==1])
exclude <- names(tab[tab>10])
if (!is.null(exclude)) {
	da <- da[!(da$field_id %in% exclude), ]
}

d <- merge(ib, da, by=c("field_id", "ref_id"))

ib1 <- ib[ib$var_rank == 1, ]
da1 <- da[da$var_rank == 1, ]
ib1$var_rank <- da1$var_rank <- NULL

d1 <- merge(ib1, da1, by=c("field_id"))
table(d1$variety.x == d1$variety.y)

z1 <- merge(da1, ib, by=c("field_id", "variety"), all.x=TRUE)
z2 <- merge(ib1, da, by=c("field_id", "variety"), all.x=TRUE)

rank_plot <- function(z, add=FALSE, main="") {
	M = c("IBS", "DAP")
	#z$var_rank[is.na(z$var_rank)] <- max(z$var_rank, na.rm=TRUE)
	z <- na.omit(z)
	if (add) {
		lines(sort(z$var_rank), (1:nrow(z))/nrow(z), lwd=2, col="red")	
		legend("bottomright", legend=paste(rev(M), "#1, ranked by", M), col=c("blue", "red"), lwd=2)
	} else {
		plot(sort(z$var_rank), (1:nrow(z))/nrow(z), xlab="Rank by other algorithm", 
			ylab="fraction of samples", las=1, type="l", lwd=2, col="blue", main=main)
	}
}

rank_plot(z1, main=gsub("_IBS.xlsx", "", basename(fi)))
rank_plot(z2, TRUE)


 


cor(d$IBS, d$Probability, use="pairwise.complete.obs")
cor(d$rank.x, d$rank.y, method = "spearman", use="pairwise.complete.obs")

dd <- d[d$rank.y <= 5 & d$rank.x <= 5, ]
cor(dd$IBS, dd$Probability, use="pairwise.complete.obs")
cor(dd$rank.x, dd$rank.y, method = "spearman", use="pairwise.complete.obs")

plot(d$IBS, d$Probability, cex=.1)

par(mfrow=c(1, 2))

i <- d$rank.x == 1
boxplot(d$rank.y[i])
j <- d$rank.y == 1
boxplot(d$rank.x[j])

i = d$rank.x < 5 | d$rank.y < 5
cor(d$IBS[i], d$Probability[i])

plot(d$rank.x[i], d$rank.y[i], cex=.1)


f = "C:/github/brian/IMAGE/data/ibs/Tanzania_Rice_matches.xlsx"
f = "C:/github/brian/IMAGE/data/ibs/Nigeria_Rice_matches.xlsx"

old <- readxl::read_excel(f, "IBS_cutoff_0.7_all_match")
old$field_id = gsub("DRi23-7955_", "", old$field_id)
old$ref_id = gsub("DRi23-7955_", "", old$ref_id)

dd <- merge(ib, old, by=c("field_id", "ref_id"))
plot(IBS.y ~ IBS.x, data=dd, cex=.1)




f = "c:/Users/rhijm/Downloads/res.csv"
x = read.csv(f)
a = x[,1:3]
b = x[,c(1, 4:5)]
m = merge(a, b, by=1:2)
plot(m[,3:4])
	
#}

f = "C:/github/brian/IMAGE/data/raw/snp/Tanzania/DArTPipelineData/rice_multi_match.csv"
do = read.csv(f)
i <- with(do, ave(Probability, SampleID, FUN=\(x) rank(1000 - x)))
do = do[i==1, ]
z <- merge(do, d, by=c("field_id", "ref_id"))


da1 = da1[order(da1[,1]), ]

d = d[order(d$field_Tid), ]
