process Extract_coverage_nodup {
      
  storeDir params.COVERAGEdir
      
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam)

  output: 
  path "${SRR}.depth.txt"
      
  """
  samtools index -b ${sorted_bam}
  samtools depth -a ${sorted_bam} > ${SRR}.depth.txt
  """
}

process Extract_coverage {
      
  storeDir params.COVERAGEdir
      
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam)

  output: 
  path "${SRR}.depth.txt"
      
  """
  samtools index -b ${sorted_bam}
  samtools depth -a ${sorted_bam} > ${SRR}.depth.txt
  """
      
}