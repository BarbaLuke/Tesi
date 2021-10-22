process Alignment_and_sorting {

  storeDir params.BAMdir
      
  tag "${SRR}"
      
  input:
  path (genome)
  tuple path("${genome}.amb"),
        path("${genome}.ann"),
        path("${genome}.bwt"),
        path("${genome}.fai"),
        path("${genome}.pac"),
        path("${genome}.sa")
  path HIV_1
  val(SRR)
  path(fastq)
      
  output:
  val("${SRR}")
  path("${SRR}.sorted.bam") 
      
  script:
  if(params.aligner == "bwa"){
  """
  bwa mem ${genome} ${fastq} \
  | samtools sort -o ${SRR}.sorted.bam
  """
  }else if(params.aligner == "bowtie2"){  
    if(params.library_preparation == 'single'){
      """
      bowtie2 -x HIV_1 ${fastq} | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
      """
    }else{
      """
      bowtie2 -x HIV_1 -1 ${SRR}_out_trim_1_repaired.fastq.gz -2 ${SRR}_out_trim_2_repaired.fastq.gz \
      | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
      """
    }
  }else{
  error "Wrong input: ${params.aligner}. It must be bowtie2 or bwa." 
  }
  stub:
  """
  touch ${SRR}.sorted.bam
  """
}