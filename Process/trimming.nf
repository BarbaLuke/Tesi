process Trimming {
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq)

  output:
  tuple val("${SRR}"), path("${SRR}.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_1.trim.fastq.gz"), path("${SRR}_2.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_1.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_1.trim.fastq.gz"), path("${SRR}_2.trim.fastq.gz") optional true  

  script:

  if(params.library_preparation == 'single'){
                
    """
    TrimmomaticSE -phred33 \
    -threads ${task.cpus} \
    -summary ${SRR}.trim.summary \
    -quiet \
    ${fastq} \
    ${SRR}.trim.fastq.gz \
    ${params.trimmomatic_setting}
    """

  }else{
    
    """
    TrimmomaticPE -phred33 \
    -threads ${task.cpus} \
    -summary ${SRR}.trim.summary \
    -quiet -validatePairs \
    ${fastq} \
    ${SRR}_1.trim.fastq.gz ${SRR}_1_unpaired.trim.fastq.gz \
    ${SRR}_2.trim.fastq.gz ${SRR}_2_unpaired.trim.fastq.gz \
    ${params.trimmomatic_setting}
    """
  }

  stub:

  if(params.library_preparation == 'single'){
                
    """
    touch ${SRR}.trim.fastq.gz
    """

  }else{
    
    """
    touch ${SRR}_1.trim.fastq.gz
    touch ${SRR}_2.trim.fastq.gz
    """
  }

}