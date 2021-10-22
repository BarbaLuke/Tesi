process Extract_coverage {
      
  storeDir params.COVERAGEdir
      
  tag "${SRR}"
      
  input:
  val(SRR)
  path(sorted_bam)

  output: 
  path "${SRR}.depth.txt"

  script:      
  """
  samtools index -b ${sorted_bam}
  samtools depth -a ${sorted_bam} > ${SRR}.depth.txt
  """

  stub:
  """
  touch ${SRR}.depth.txt
  """
      
}