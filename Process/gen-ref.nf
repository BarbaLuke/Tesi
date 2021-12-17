process Generate_Ref_files_screen {
  
  input:
  path genomeFA

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path ('*.bt2')
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path ('*.bt2')

  script:
  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bwa index ${genomeFA}
  bowtie2-build ${genomeFA} HIV_1
  """

  stub:
  """
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
  """
}

process Generate_Ref_files {
  storeDir "${genomeFA.toRealPath().getParent()}"

  input:
  path genomeFA

  output:
  tuple path('*.fasta.amb'), path('*.fasta.ann'), path('*.fasta.bwt'), path('*.fasta.fai'), path('*.fasta.pac'), path('*.fasta.sa')
  path('*.bt2')

  script:
  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bwa index ${genomeFA}
  bowtie2-build ${genomeFA} HIV_1
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
  """
}

process Downloading_human_genome {
  storeDir 'FastQ-Screen/index/human'

  output:
  path('*.fna.gz')

  script:
  """
  wget https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz 
  """

  stub:
  """
  touch GRCh38_latest_genomic.fna.gz
  """
}

process Generate_Ref_files_human {
  storeDir 'FastQ-Screen/index/human'

  input:
  path human

  output:
  tuple path('*.amb'), path('*.ann'), path('*.bwt'), path('*.fai'), path('*.pac'), path('*.sa')
  path('Human*')

  script:
  """
  bwa index ${human}
  bowtie2-build ${human} Human
  """

  stub:
  """
  touch ${human}.ann
  touch ${human}.bwt
  touch ${human}.fai
  touch ${human}.pac
  touch ${human}.sa
  touch ${human}.amb
  touch Human.1.bt2
  touch Human.rev.2.bt2
  touch Human.rev.1.bt2
  touch Human.4.bt2
  touch Human.3.bt2
  touch Human.2.bt2
  """
}