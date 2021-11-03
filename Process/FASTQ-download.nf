process FASTQs_download {
  tag "${SRR}" 

  input:
  val SRR

  output:
  val("${SRR}")
  path("${SRR}*.fastq.gz")
  path("${SRR}*.fastq.gz")
   
        
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