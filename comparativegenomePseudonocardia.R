#Pseudonocardia comparative genome analysis R script

library(ggplot2)

###Genome size and GC from anvio
#use anvio to export misc. data table
meta <- read.table("/home/jenny/Desktop/pseudo_for_writeup/anvio/plus82exportmisc", header=TRUE, row.names =1, sep='\t', skip=0)

#Genome length comparison and significance test
ggplot(meta, aes(x=clade, y=total_length, fill=clade)) + geom_boxplot(notch=TRUE) + labs(x="Host",y="Genome Length") +theme_classic() + theme(text=element_text(size=21),axis.text=element_text(size=16),legend.position="none")
shapiro.test(meta$total_length)
#p-value > 0.05 implies distribution
t.test(meta$total_length~meta$clade, var.equal=TRUE)
wilcox.test(meta$total_length~meta$clade)

#GC content comparison and significance test
ggplot(meta, aes(x=host, y=gc_content, fill=host)) + geom_boxplot(notch=TRUE) + labs(x="Host",y="GC Content") +theme_classic() + theme(axis.text=element_text(size=14),legend.position="none")
shapiro.test(meta$gc_content)
#p-value > 0.05 implies normal distribution
t.test(meta$gc_content~meta$host, var.equal=TRUE)
wilcox.test(meta$gc_content~meta$host)

###Orthologs
#import orthologs from pyparanoid output
allortho <- read.table("/home/jenny/Desktop/pseudo_for_writeup/pyparanoid/pseudogroupsoutredo82/homolog_matrix.txt", header=TRUE, row.names =1, sep='\t', skip=0)
allortho <- as.matrix(allortho)
#OR convert to 1 or 0 matrix and sum all
allortho[allortho > 1] <- 1
orthototal <- rowSums(allortho)
test <- colSums(allortho)
hist(orthototal)
orthototaldf <- data.frame(orthototal)
ggplot (orthototaldf, aes(x=orthototal)) +geom_histogram(binwidth=2,alpha=0.5,fill="gray",color="black") + labs(x="Number of Strains",y="Number of Genes") + theme_classic()
cutoff = .95*ncol(allortho)
higher <- data.frame(x=orthototal,above=orthototal>cutoff)
qplot(x,data=higher,geom="histogram",fill=above,binwidth=1)  + theme(legend.position=c(0.8,0.5),legend.title=element_blank()) + labs(x="Number of Strains",y="Number of Homologs") +scale_fill_manual(values=c("#56B4E9","#E69F00"),labels=c("Accessory Genes","Soft Core (>95%)"))


###estimating genome size with jellyfish test
antarcticamer <- read.table("/home/jenny/tools/jellyfish-2.3.0/antarctica_histo.txt")
plot(antarcticamer[1:200, ])
