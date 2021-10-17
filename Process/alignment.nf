process Alignment_and_sorting_single {

  storeDir params.BAMdir
  
  tag "${SRR}"
      
  input:
  path "genome.fasta"
  tuple path('genome.fasta.amb'),
        path('genome.fasta.ann'),
        path('genome.fasta.bwt'),
        path('genome.fasta.fai'),
        path('genome.fasta.pac'),
        path('genome.fasta.sa')
  path HIV_1
  tuple val(SRR), path(fastq)
      
  output:
  tuple val(SRR), path("${SRR}.sorted.bam")
      

  script:
  if( params.aligner == "bwa")
  """
  bwa mem genome.fasta \
  -t ${task.cpus} \
  ${fastq} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
  if( params.aligner == "bowtie2")
  """
  bowtie2 -x HIV_1 ${fastq} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
}

process Alignment_and_sorting_paired {

  storeDir params.BAMdir
      
  tag "${SRR}"
      
  input:
  path "genome.fasta"
  tuple path('genome.fasta.amb'),
        path('genome.fasta.ann'),
        path('genome.fasta.bwt'),
        path('genome.fasta.fai'),
        path('genome.fasta.pac'),
        path('genome.fasta.sa')
  path HIV_1
  tuple val(SRR), path(fastq)
      
  output:
  tuple val(SRR), path("${SRR}.sorted.bam") 
      
  script:
  if(params.aligner == "bwa"){
  """
  bwa mem genome.fasta \
  -t ${task.cpus} \
  ${fastq} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
  }else if(params.aligner == "bowtie2"){  
  """
  bowtie2 -x HIV_1 -1 ${SRR}_out_trim_1.fastq.gz -2 ${SRR}_out_trim_2.fastq.gz \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
  }else{
  error "Wrong input: ${params.aligner}. It must be bowtie2 or bwa." 
  }

  stub:
  """
  touch ${SRR}.sorted.bam
  """
}