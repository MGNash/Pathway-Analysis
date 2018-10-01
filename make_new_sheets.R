setwd("C:/Users/Michael Nash/Documents/job search/2018/Github_proj/pathway_analysis")
library(stringi)
library(readxl)
library(xlsx)
library(openxlsx)
Serum.sheet = read_excel("NIHMS860664-supplement-Supp_info.xlsx",sheet=2)

# randomly selecting 90% of the protein names from the supplement in the paper to use in generating pseudo data
# if I use 100% and get KEGG pathway results on all of them, I might be replicating some unpublished results
set.seed(12345)
all.serum.to.use = sample(as.character(Serum.sheet$`UniProtKB Name`),as.integer(length(Serum.sheet$`UniProtKB Name`)*.9),replace=FALSE)
#head(all.serum.to.use)
makelong = function(short){
  digit.i = stri_rand_strings(1,5,'[0-9]')
  letter.i = sample(c("P","Q","O"),1,replace=TRUE,prob = c(.5,.4,.1))
  long = paste0("sp|",letter.i,digit.i,"|",short)
  return(long)
}
all.serum.long = unlist(lapply(all.serum.to.use,makelong))

# randomly selecting 70% of the protein names from all those available to use as serum protein names
set.seed(23456)
serum.name.list.pseudo = sample(all.serum.to.use,as.integer(length(all.serum.to.use)*.7),replace=FALSE)
#head(serum.name.list.pseudo)

# randomly selecting 70% of the protein names from all those available to use as muscle protein names
set.seed(34567)
muscle.index.all.pseudo = sample(1:length(all.serum.to.use),as.integer(length(all.serum.to.use)*.7),replace=FALSE)
muscle.name.all.pseudo = all.serum.to.use[muscle.index.all.pseudo]
muscle.long.all.pseudo = all.serum.long[muscle.index.all.pseudo]
# the expected overlap between muscle proteins and serum proteins is just under 50%
# of course, we have to break our muscle proteins in 6 and not all will end up in the final sheet
#head(muscle.name.all.pseudo)

# choosing number of proteins in each muscle sample
muscle.list = rep(list(NULL),6)
set.seed(45678)
#lowp = .5
#highp=.66
lowp = .7
highp = .9
n.muscle = as.integer(
  seq(as.integer(length(muscle.name.all.pseudo)*lowp),
               as.integer(length(muscle.name.all.pseudo)*highp),
               length.out = 6) + rnorm(6,0,30))
#n.muscle

# making sheets containing lists of proteins for each of six muscle samples
count.ip = c(7782,8010-7782,54,30,6,0,6,0,12)
prob.ip = count.ip/sum(count.ip)

getIP = function(nIP){
  #short.list =  sample(all.serum.to.use,nIP,replace=FALSE)
  #long.list = unlist(lapply(short.list,makelong))
  long.list =  sample(all.serum.long,nIP,replace=FALSE)
  return(paste(long.list,collapse="; "))
}

set.seed(56789)
for(i in 1:6){
  muscle.index.i = sample(1:length(muscle.name.all.pseudo),n.muscle[i],replace=FALSE)
  muscle.names.i = muscle.long.all.pseudo[muscle.index.i]
  count.ip.i = sample(0:8,n.muscle[i],replace=TRUE,prob=prob.ip)
  ip.i = rep("-",n.muscle[i])
  ip.i[count.ip.i>0] = unlist(lapply(count.ip.i[count.ip.i>0],getIP))
  logdsin.i = runif(n.muscle[i],-28,-13)
  prob.i = rep(1,n.muscle[i])
  prob.i.not1 = sample(c(TRUE,FALSE),n.muscle[i],replace=TRUE,prob=c(1/3,2/3))
  prob.i[prob.i.not1] = runif(sum(prob.i.not1),.8,1)
  muscle.list[[i]] = data.frame(Probability = prob.i,
                                Protein = as.character(muscle.names.i),
                                Indistinguishable_Proteins = ip.i,
                                LogdSIn = logdsin.i)
  muscle.list[[i]]$Protein = as.character(muscle.list[[i]]$Protein)
  muscle.list[[i]]$Indistinguishable_Proteins = as.character(muscle.list[[i]]$Indistinguishable_Proteins)
  
  colnames(muscle.list[[i]])[4] = "Log(dSIn)"
  #createSheet(IMBSR2.book,sheetName = paste0("sample_",i))
  #addDataFrame(muscle.list[[i]],)
  #write.xlsx2(muscle.list[[i]],"IMBSR2.xlsx",sheetname = "sample6")
}
#head(muscle.list[[6]])

# adding a non-human protein to one of the muscle samples, as in the real muscle protein results
nonhuman.protein = "sp|UBB_BOVIN"

set.seed(67890)
add.to.list = sample(1:6,1)
replace.entry = sample(1:length(muscle.list[[add.to.list]]),1)
muscle.list[[add.to.list]]$Protein[replace.entry] = nonhuman.protein

# adding 'NACAM_HUMAN' to one of the muscle samples and 'NACA_HUMAN' as an indistiguishable protein, 
# because this protein created some name-related confusion
# which I then resolved

set.seed(78901)
add.to.list = sample(1:6,1)
replace.entry = sample(1:length(muscle.list[[add.to.list]]$Protein),1)
muscle.list[[add.to.list]]$Protein[replace.entry] = "sp|R12345|NACAM_HUMAN"
add.to.list
replace.entry

set.seed(89012)
add.to.list = sample(1:6,1)
replace.entry = sample(1:length(muscle.list[[add.to.list]]$Indistinguishable_Proteins),1)
muscle.list[[add.to.list]]$Indistinguishable_Proteins[replace.entry] = "sp|R12345|NACA_HUMAN"
add.to.list
replace.entry

#add.to.list
#replace.entry

names(muscle.list) = paste0("sample_",1:6)
write.xlsx(muscle.list,"muscle.xlsx")

serum.df = data.frame('UniProtKB Name' = serum.name.list.pseudo)
names(serum.df) = 'UniProtKB Name'
serum.list = list(NULL,serum.df,NULL)
names(serum.list) = c("T1. DAVID bone loss list","T2. DAVID background list","T3.DAVID GO Cellular Enrichment")
write.xlsx(serum.list,"serum.xlsx")

set.seed(78901)
serum_assoc.long = sample(serum.name.list.pseudo,28,replace=FALSE)
getshort = function(x){return(unlist(strsplit(x,"_",fixed=TRUE))[1])}
serum_assoc.short = unlist(lapply(serum_assoc.long,getshort))
#head(serum_assoc.short)
serum_assoc.df = data.frame(serum_assoc.short)
colnames(serum_assoc.df) = NULL
rownames(serum_assoc.df) = NULL
serum_assoc.list = list(serum_assoc.df)
write.xlsx(serum_assoc.list,"serum_assoc2.xlsx")





