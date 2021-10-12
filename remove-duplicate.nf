process Remove_duplicated_reads {
      
  storeDir params.BAMdir
      
  tag "${SRR}"
    
  input:
  tuple val(SRR), path(sorted_bam)
      
  output:
  tuple val(SRR), path("${SRR}.nodup.sorted.bam")
      
  """
  PicardCommandLine MarkDuplicates I=${sorted_bam} O=${SRR}.nodup.sorted.bam M=${SRR}.nodup.sorted.metrics.txt REMOVE_DUPLICATES=true
  """
}