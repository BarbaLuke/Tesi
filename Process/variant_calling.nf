process Variant_calling_bowtie2 {
  storeDir params.VCFdir
    
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam)
  path 'genome.fasta'
  path('*.fasta.fai')
  path HIV_1
      
  output:
  path "${SRR}.vcf"

  script:      
  """
  samtools mpileup -f genome.fasta ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${params.varscan} > ${SRR}.vcf  
  """

  stub:
  """
  touch ${SRR}.vcf
  """
}

process Variant_calling_bwa {
  storeDir params.VCFdir
    
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam)
  path 'genome.fasta'
  tuple path('genome.fasta.amb'),
        path('genome.fasta.ann'),
        path('genome.fasta.bwt'),
        path('genome.fasta.fai'),
        path('genome.fasta.pac'),
        path('genome.fasta.sa') from genomeIndexed
  path('*.fasta.fai')
      
  output:
  path "${SRR}.vcf"

  script:
  """
  samtools mpileup -f genome.fasta ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${params.varscan} > ${SRR}.vcf  
  """

  stub:
  """
  touch ${SRR}.vcf
  """
}