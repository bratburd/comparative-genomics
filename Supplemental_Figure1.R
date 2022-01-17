###Supplemental Figure 1
##Survival of ants
library(ggplot2)
library("scales")
library(reshape2)
library(survminer)
library("survival")
library(dplyr)
antsurv <- read.table("C:/Users/bratb/Documents/Pseudo/treatmentdeath.csv", header=TRUE,sep=',')#("/home/jenny/Desktop/pseudo_for_writeup/antcolonizeexperiment/treatmentdeath.csv", header=TRUE,sep=',')
View(antsurv)
#omit NA and question mark treatments
antsurv_noNA <- na.omit(antsurv)
antsurv_noNA <- subset(antsurv_noNA, treatment != "??")
View(antsurv_noNA)
fit <- survfit(Surv(totaldaysnumonly)~treatment, data=antsurv_noNA)
summary(fit)
print(fit)
ggsurvplot(fit,pval=TRUE, conf.int=FALSE,risk.table=FALSE, legend.labs=c("alaniphila","alni","antarctica","CC031209-02","chloroethenvirons",
                                                                         "compacta","cypriaca","endophytica","kongjuensis","kujensis","NC",
                                                                         "nitrificans","AL050505-11","petroleophila","S. coelicolor","saturnea",
                                                                         "SID10815","spinosispora","zijingensis"))
#plot for subcategories for better visualization
justbasal <- subset(antsurv_noNA,treatment=="spinosispora" | treatment=="S. coelicolor" | treatment=="SID10815" | treatment=="chloroethenvirons" |
                      treatment=="petroleophila" | treatment=="compacta" | treatment=="alaniphila" | treatment=="zijingensis" | treatment=="cypriaca" |
                      treatment=="NC")
View(justbasal)
fit <- survfit(Surv(totaldaysnumonly)~treatment, data=justbasal)
ggsurvplot(fit,pval=TRUE, conf.int=FALSE,risk.table=FALSE,legend.labs=c("Ant Isolates", "Basal Isolates", "Derived Isolates", "Negative Control"))#, legend.labs=c("alaniphila","alni","antarctica","CC031209-02","chloroethenvirons",


justderived <- subset(antsurv_noNA,treatment=="alni" | treatment=="kujensis" | treatment=="endophytica" | treatment=="AL050505-11" |
                        treatment=="saturnea" | treatment=="kongjuensis" | treatment=="CC031209-02" | treatment=="nitrificans" | treatment=="antarctica" |
                        treatment=="NC")
View(justderived)
fit <- survfit(Surv(totaldaysnumonly)~treatment, data=justderived)
ggsurvplot(fit,pval=TRUE, conf.int=FALSE,risk.table=FALSE)

#combine ant, non ant, strept, and NC and plot averages
#antsurv_noNA$majorgroup <- ifelse(antsurv_noNA$treatment)
antsurvmg <- antsurv_noNA %>% mutate(majorgroup = case_when(treatment=="spinosispora" | treatment=="chloroethenenvirons" |
                                                              treatment=="petroleophila" | treatment=="compacta" | treatment=="alaniphila" | treatment=="zij" | treatment=="cypriaca" 
                                                            ~ "Basal",
                                                            treatment=="alni" | treatment=="kujensis" | treatment=="endophytica" |
                                                              treatment=="saturnea" | treatment=="kongjuensis" | treatment=="nitrificans" | treatment=="antarctica"
                                                            ~ "Derived",
                                                            treatment=="CC"|treatment=="PC" ~ "Ant Isolates",
                                                            treatment=="NC" ~ "NC",
                                                            treatment=="SID10815"|treatment=="S. coelicolor" ~ "Streptomyces"))
View(antsurvmg)
fit <- survfit(Surv(totaldaysnumonly)~majorgroup, data=antsurvmg)
ggsurvplot(fit,pval=TRUE, conf.int=FALSE,risk.table=FALSE,legend.labs=c("Ant Isolates", "Basal Isolates", "Derived Isolates", "Negative Control","Streptomyces"))
#update for publishing - Cameron wants to remove supplemental references Streptomyces colonization experiment
antsurvmg_nostrept <- subset(antsurvmg, majorgroup != "Streptomyces")
View(antsurvmg_nostrept)
fit <- survfit(Surv(totaldaysnumonly)~majorgroup, data=antsurvmg_nostrept)
ggsurvplot(fit,pval=FALSE, conf.int=FALSE,risk.table=FALSE,legend.labs=c("Ant Isolates", "Basal Isolates", "Derived Isolates", "Negative Control"))


#log rank test
surv_diff <- survdiff(Surv(totaldaysnumonly)~treatment, data=antsurv_noNA)
surv_diff
pairwise_survdiff(Surv(totaldaysnumonly)~treatment,data=antsurv_noNA,p.adjust.method="fdr")