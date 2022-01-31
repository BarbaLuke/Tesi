process FASTQs_download {
  tag "${SRR}"

  input:
  val SRR

  output:
  tuple val("${SRR}"), path("${SRR}*.fastq")

  script: 
  if(params.download == 'local'){
    """
    fastq-dump --split-files ${SRR}
    """
  }else{
    """
    #!/bin/sh
    fasterq-dump --split-files ${SRR}
    """
  }
  
  stub:
  if(params.download == 'local'){
    """
    touch ${SRR}_1.fastq
    touch ${SRR}_2.fastq
    """
  }else{
    """
    #!/bin/sh
    touch ${SRR}_1.fastq
    touch ${SRR}_2.fastq
    """
  }
}