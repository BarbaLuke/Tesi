process Trimming_paired {

  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq_1_2) from FASTQ_paired.mix(FASTQ_files_paired)
      
  output:
  tuple val("${SRR}"), 
        path("${SRR}_1.trim.fastq.gz"), 
        path("${SRR}_2.trim.fastq.gz") into TRIMMED_paired
            
      
  """
  TrimmomaticPE -phred33 \
  -threads ${task.cpus} \
  -summary ${SRR}.trim.summary \
  -quiet -validatePairs \
  ${fastq_1_2} \
  ${SRR}_1.trim.fastq.gz ${SRR}_1_unpaired.trim.fastq.gz \
  ${SRR}_2.trim.fastq.gz ${SRR}_2_unpaired.trim.fastq.gz \
  ${params.trimmomatic_setting}
  """
}