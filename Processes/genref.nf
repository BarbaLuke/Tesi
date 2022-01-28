process Generate_Ref_files {

  input:
  path ref

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path('*.bt2')
  tuple path('*.smi'), path('*.sma')

  script:
  """
  samtools faidx ${ref} -o ${ref}.fai 
  bwa index ${ref}
  bowtie2-build ${ref} reference
  smalt index -k 14 -s 8 reference ${ref}
  """

  stub:
  """
  touch ${ref}.fai
  touch ${ref}.ann
  touch ${ref}.bwt
  touch ${ref}.fai
  touch ${ref}.pac
  touch ${ref}.sa
  touch ${ref}.amb
  touch reference.1.bt2
  touch reference.rev.2.bt2
  touch reference.rev.1.bt2
  touch reference.4.bt2
  touch reference.3.bt2
  touch reference.2.bt2
  touch reference.smi
  touch reference.sma
  """
}

process Download_Human_Genome {

  input:
  val HUgenome

  output:
  tuple path("GRCh38_latest_genomic.fna"), path("ref")

  script:
  """
  wget ${HUgenome}
  gunzip GRCh38_latest_genomic.fna.gz
  bbsplit.sh ref=GRCh38_latest_genomic.fna
  """

  stub:
  """
  touch GRCh38_latest_genomic.fna
  mkdir ref
  """

}
