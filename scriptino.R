library("optparse")

option_list = list(
  make_option(c("-t", "--txt_file1"), type="character", default="list.txt", help="Input file in TXT", metavar="character"),
  make_option(c("-b", "--txt_file2"), type="character", default="list.txt", help="Input file in TXT", metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

table_of_mapping1=read.delim(opt$txt_file1, row.names=1)
table_of_mapping2=read.delim(opt$txt_file2, row.names=1)

no_mapping_score1 = table_of_mapping1$X.Unmapped.1[2]
no_mapping_score2 = table_of_mapping2$X.Unmapped.1[2]
if(no_mapping_score1 > 30 && no_mapping_score2 > 30){
  cat("no")
}else{
  cat("yes")
}
