process FASTQs_download {
  echo true
  tag "${SRR}"

  input:
  val SRR
  path(ciaone)
  output:
  val(SRR)

  script: 
  //println ciaone.text
  """
  head ${ciaone}
  """
  //paired = "PAIRED"
  /*if(paired_or_single.toString().trim() == paired[0]){
    if(params.download == "local"){
      """
      fastq-dump --split-files ${SRR}
      """
    }else{
      """
      #!/bin/sh
      fasterq-dump --split-files ${SRR}
      """
    }
  }else{
    if(params.download == "env"){
      """
      fastq-dump ${SRR}
      """
    }else{
      """
      #!/bin/sh
      fasterq-dump ${SRR}
      """
    }
  }*/
  
  stub:
  paired = "PAIRED"
  if(paired_or_single[0] == paired[0]){
    """
    > ${SRR}_1.fastq
    > ${SRR}_2.fastq
    """
  }else{
    """
    > ${SRR}.fastq

    """
  }
}