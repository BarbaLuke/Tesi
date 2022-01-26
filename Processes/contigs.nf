process Contigs {
  tag "${SRR}"

  input:
  tuple val(SRR), path(fastq)

  output:
  tuple val(SRR), path("MyOutputDirectory${SRR}/contigs.fasta"), path(fastq)
  
  script:
  """
  iva -t ${task.cpus} -f corr_${SRR}_1.fastq -r corr_${SRR}_2.fastq MyOutputDirectory${SRR}
  """

  stub:
  """
  mkdir MyOutputDirectory${SRR}
  touch MyOutputDirectory${SRR}/contigs.fasta
  """
}