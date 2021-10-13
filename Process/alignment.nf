process Alignment_and_sorting_single {

  storeDir params.BAMdir
  
  tag "${SRR}"
      
  input:
  val siOno
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
      
  when:
  siOno == "yes"

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
  val siOno
  path "genome.fasta"
  tuple path('genome.fasta.amb'),
        path('genome.fasta.ann'),
        path('genome.fasta.bwt'),
        path('genome.fasta.fai'),
        path('genome.fasta.pac'),
        path('genome.fasta.sa')
  path HIV_1
  tuple val(SRR), path(fastq_1), path(fastq_2)
      
  output:
  tuple val(SRR), path("${SRR}.sorted.bam") 

  when:
  siOno == "yes" 
      
  script:
  if(params.aligner == "bwa")
  """
  bwa mem genome.fasta \
  -t ${task.cpus} \
  ${fastq_1} ${fastq_2} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
  if(params.aligner == "bowtie2")
  """
  bowtie2 -x HIV_1 -1 ${fastq_1} -2 ${fastq_2} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """

  stub:
  """
  touch ${SRR}.sorted.bam
  """
}