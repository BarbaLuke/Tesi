process Contigs {
  tag "${SRR}"

  input:
  val(SRR)
  path(fastq)

  output:
  val("${SRR}")
  path("MyOutputDirectory${SRR}/contigs.fasta")
  path("MyOutputDirectory${SRR}/contigs.fasta")
  
  script:

  if(params.library_preparation == 'single'){

    """
    iva --fr ${SRR}.fastq.gz MyOutputDirectory${SRR}
    """

  }else{
    
    """
    iva  -f ${SRR}_1.fastq.gz -r ${SRR}_1.fastq.gz MyOutputDirectory${SRR}
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