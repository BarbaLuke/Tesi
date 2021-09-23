process FASTQs_download_paired {

  storeDir params.FASTQdir

  tag "${SRR}" 

  input:
  val SRR
        
  output:
  tuple val(SRR), path("${SRR}_*.fastq.gz")

  """
  fastq-dump --split-files --gzip ${SRR}
  """
}

process FASTQs_download_single {

  storeDir params.FASTQdir

  tag "${SRR}" 
      
  input:
  val SRR
    
  output:
  path "${SRR}.fastq.gz"
      
  """
  fastq-dump --gzip ${SRR}
  """
}