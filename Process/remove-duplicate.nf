process Remove_duplicated_reads {
      
  storeDir params.BAMdir
      
  tag "${SRR}"
    
  input:
  val(SRR)
  path(sorted_bam)
      
  output:
  val("${SRR}")
  path("${SRR}.nodup.sorted.bam")

  script:      
  """
  PicardCommandLine MarkDuplicates I=${sorted_bam} O=${SRR}.nodup.sorted.bam M=${SRR}.nodup.sorted.metrics.txt REMOVE_DUPLICATES=true
  """

  stub:
  """
  touch ${SRR}.nodup.sorted.bam
  """
}