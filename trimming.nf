process Trimming_paired {

  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq_1_2)
      
  output:
  tuple val("${SRR}"), 
        path("${SRR}_1.trim.fastq.gz"), 
        path("${SRR}_2.trim.fastq.gz")
            
      
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

process Trimming_single { 
    
  tag "${fastq.simpleName}"
      
  input:
  path fastq
      
  output:
  tuple val("${fastq.simpleName}"), 
        path("${fastq.simpleName}.trim.fastq.gz")
            
  when:
  params.library_preparation == 'single'
      
  """
  TrimmomaticSE -phred33 \
  -threads ${task.cpus} \
  -summary ${fastq.simpleName}.trim.summary \
  -quiet \
  ${fastq} \
  ${fastq.simpleName}.trim.fastq.gz \
  ${params.trimmomatic_setting}
  """
}