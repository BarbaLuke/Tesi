process Variant_calling_nodup {
      
  storeDir params.VCFdir
    
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam)
      
  path 'genome.fasta'

  path('*.fasta.fai')
  path HIV_1
      
  output:
  path "${SRR}.vcf"
      
  """
  samtools mpileup -f genome.fasta ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${params.varscan} > ${SRR}.vcf  
  """
}

process Variant_calling {
      
  storeDir params.VCFdir
      
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam) from SORTED_paired_calling.mix(SORTED_single_calling)
      
  path "genome.fasta" from genomeFAch 
      
  path('*.fasta.fai') from genomeIndexed1
  path HIV_1 from genomeIndexed
      
  output:
  path "${SRR}.vcf" into VCF
      
  """
  samtools mpileup -f genome.fasta ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${params.varscan} > ${SRR}.vcf  
  """
}