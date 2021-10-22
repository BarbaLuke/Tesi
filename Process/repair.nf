process Repair {
      
  tag "${SRR}"
      
  input:
  val(SRR)
  path(to_repair)

  output: 
  val("${SRR}")
  path ("*_repaired.fastq.gz")
  path ("*_repaired_unpaired.fastq.gz")

  script:  
  """
  repair.sh in1=${SRR}_out_trim_1.tagged_filter.fastq.gz in2=${SRR}_out_trim_2.tagged_filter.fastq.gz out1=${SRR}_out_trim_1_repaired.fastq.gz out2=${SRR}_out_trim_2_repaired.fastq.gz outs=${SRR}_repaired_unpaired.fastq.gz repair
  """

  stub:
  """
  touch ${SRR}_out_trim_1_repaired.fastq.gz
  touch ${SRR}_out_trim_2_repaired.fastq.gz
  """
}