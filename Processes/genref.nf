process Generate_Ref_files {

  input:
  path genomeFA

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path('*.bt2')
  tuple path('*.smi'), path('*.sma')

  script:
  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bwa index ${genomeFA}
  bowtie2-build ${genomeFA} HIV_1
  smalt index -k 14 -s 8 HIV_1 ${genomeFA}
  """

  stub:
  """
  touch ${genomeFA}.fai
  touch ${genomeFA}.ann
  touch ${genomeFA}.bwt
  touch ${genomeFA}.fai
  touch ${genomeFA}.pac
  touch ${genomeFA}.sa
  touch ${genomeFA}.amb
  touch HIV_1.1.bt2
  touch HIV_1.rev.2.bt2
  touch HIV_1.rev.1.bt2
  touch HIV_1.4.bt2
  touch HIV_1.3.bt2
  touch HIV_1.2.bt2
  touch HIV_1.smi
  touch HIV_1.sma
  """
}