process Extract_coverage {
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam), path(sorted_bam_bai)

  output: 
  path ("${SRR}.depth.txt")

  script:      
  """
  samtools depth -a ${sorted_bam} > ${SRR}.depth.txt
  """

  stub:
  """
  touch ${SRR}.depth.txt
  """  
}