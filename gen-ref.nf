process Generate_Ref_files_screen {
  storeDir 'FastQ-Screen/index/hiv'

  input:
  path genomeFA

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path('HIV_1*')
  path('*.fasta.fai')

  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bwa index ${genomeFA}
  bowtie2-build ${genomeFA} HIV_1
  """
}

process Generate_Ref_files {
  storeDir "${genomeFA.toRealPath().getParent()}"

  input:
  path genomeFA

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path('HIV_1*')
  path('*.fasta.fai')

  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bwa index ${genomeFA}
  bowtie2-build ${genomeFA} HIV_1
  """
}

process Downloading_human_genome {
  storeDir 'FastQ-Screen/index/human'

  output:
  
  path('*.fna.gz')

  """
  wget https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz 
  """
}

process Generate_Ref_files_human {
  storeDir 'FastQ-Screen/index/human'

  input:
  path human

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path('HIV_1*')

  """
  bwa index ${human}
  bowtie2-build ${human} Human
  """
}