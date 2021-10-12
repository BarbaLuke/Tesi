install.packages("optparse")
library("optparse")

option_list = list(
  make_option(c("-t", "--txt_file"), type="character", default="list.txt", help="Input file in TXT", metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

table_of_mapping=read.delim(opt$txt_file, row.names=1)

no_mapping_score = table_of_mapping$X.Unmapped.1[2]
if(no_mapping_score > 30){
  cat("no")
}else{
  cat("yes")
}