process FASTQs_download {

  storeDir params.FASTQdir

  tag "${SRR}" 

  input:
  val SRR

  output:
  tuple val("${SRR}"), path("${SRR}.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_*.fastq.gz") optional true
        
  script:

  if(params.library_preparation == 'single'){
    """
    fastq-dump --gzip ${SRR}
    """
  }else{
    """
    fastq-dump --split-files --gzip ${SRR}
    """
  }

  stub:

  if(params.library_preparation == 'single'){
    """
    touch ${SRR}.fastq.gz
    """
  }else{
    """
    touch ${SRR}_1.fastq.gz
    touch ${SRR}_2.fastq.gz
    """
  }

}