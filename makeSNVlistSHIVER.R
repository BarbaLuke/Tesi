library(seqinr)
library(foreach)
library(doFuture)
## reference sequence 
reference_fasta <- read.fasta(file = "HIV_1.fasta", as.string = F, forceDNAtolower = FALSE)[[1]]
## list of csv file (output from SHIVER)
listcsv <- dir(pattern = "*.csv")
## planning multi-worker for parallel computing
plan(multisession, workers = 7)
registerDoFuture()
## computing SNV_list
SNV_List_ricerca <- foreach(i=1:length(listcsv), .combine='rbind', .inorder=TRUE) %dopar% {
  ## need to get the sample id from file-name
  sample_id <- strsplit(listcsv[i], "_")[[1]][1]
  ## table from csv files
  csv_file <- read.csv(listcsv[i])
  ## need this to count the number of all reads supporting the sample
  conta_tot_sample <- 0

  foreach(j=1:length(csv_file$Position.in.B.FR.83.HXB2_LAI_IIIB_BRU.K03455), .combine='rbind', .inorder=TRUE) %do% {
    ## position of this base in reference
    posizione <- as.numeric(csv_file$Position.in.B.FR.83.HXB2_LAI_IIIB_BRU.K03455[j])
    ## base of the reference sequence in this position
    ref_base <- toString(reference_fasta[posizione])
    ## initializing alternative
    alternative <- 0
    ## codon where in center ref_base
    tri_base <- paste(toString(reference_fasta[posizione - 1]), toString(reference_fasta[posizione]), toString(reference_fasta[posizione + 1]), sep="")
    ## initializing number of reads supporting the mutation
    conta_var <- 0
    ## counting total number of reads supporting this position
    conta_tot <- csv_file$A.count[j] + csv_file$C.count[j] + csv_file$G.count[j] + csv_file$T.count[j]

    conta_tot_sample <- conta_tot_sample + conta_tot
    
    variant_id <- ""
    ## need to initialize this, but then deleted
    nuovo <- data.frame("SampleId" = "uno", "VariantId" = "unoa_c", "Position" = 1, "Reference" = "A", "Alternative" = "C", "ReferenceTrinucleotide" = "ACT", "VariantCount" = 234, "TotalCount" = 300, "VariantFrequency" = 0.7, "Pvalue" = 0.1, "Conta_Tot_Sample" = 0)
    ## filtering mutation
    if(conta_tot >= 100 && csv_file$Position.in.B.FR.83.HXB2_LAI_IIIB_BRU.K03455[j] != "-" && toString(csv_file[j,3]) == ref_base){
      ## at this point the mutation could be A, C, G or T.
      if(csv_file$C.count[j] != 0 && ref_base != "C"){
        alternative <- "C"
        conta_var <- csv_file$C.count[j]
        if((conta_var/conta_tot) > 0.05){
          variant_id <- paste(posizione, ref_base, alternative, sep = "_")
          nuovo <- rbind(nuovo, list(sample_id, variant_id, posizione, ref_base, alternative, tri_base, conta_var, conta_tot, (conta_var/conta_tot), 0, conta_tot_sample))
        }
      }
      if(csv_file$G.count[j] != 0 && ref_base != "G"){
        alternative <- "G"
        conta_var <- csv_file$G.count[j]
        if((conta_var/conta_tot) > 0.05){
          variant_id <- paste(posizione, ref_base, alternative, sep = "_")
          nuovo <- rbind(nuovo, list(sample_id, variant_id, posizione, ref_base, alternative, tri_base, conta_var, conta_tot, (conta_var/conta_tot), 0, conta_tot_sample))
        }
      }
      if(csv_file$T.count[j] != 0 && ref_base != "T"){
        alternative <- "T"
        conta_var <- csv_file$T.count[j]
        if((conta_var/conta_tot) > 0.05){
          variant_id <- paste(posizione, ref_base, alternative, sep = "_")
          nuovo <- rbind(nuovo, list(sample_id, variant_id, posizione, ref_base, alternative, tri_base, conta_var, conta_tot, (conta_var/conta_tot), 0, conta_tot_sample))
        }
      }
      if(csv_file$A.count[j] != 0 && ref_base != "A"){
        alternative <- "A"
        conta_var <- csv_file$T.count[j]
        if((conta_var/conta_tot) > 0.05){
          variant_id <- paste(posizione, ref_base, alternative, sep = "_")
          nuovo <- rbind(nuovo, list(sample_id, variant_id, posizione, ref_base, alternative, tri_base, conta_var, conta_tot, (conta_var/conta_tot), 0, conta_tot_sample))
        }
      }
      ## deleting no-sense rows
      if(nrow(nuovo) > 1){
        nuova <- nuovo[!nuovo$SampleId == "uno",]
        nuova
      }else if(j == length(csv_file$Position.in.B.FR.83.HXB2_LAI_IIIB_BRU.K03455) && nrow(nuovo) == 1){
        nuovo <- rbind(nuovo, list(sample_id, "nessuna", posizione, "nessuna", "nessuna", "nessuna", 0, conta_tot, 0, 0, conta_tot_sample))
        nuova <- nuovo[!nuovo$SampleId == "uno",]
        nuova
      }
    }
  }
}

SNV_list <- SNV_List_ricerca[!SNV_List_ricerca$VariantId == "nessuna", -11]

write.table(SNV_list,"SNV_list.txt",sep=";",row.names=FALSE, quote=FALSE)