process Alignment_and_sorting {
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq_align_1), path(fastq_align_2)
  path (genome)
  tuple path("${genome}.amb"),
        path("${genome}.ann"),
        path("${genome}.bwt"),
        path("${genome}.fai"),
        path("${genome}.pac"),
        path("${genome}.sa")
  path HIV_1_Bowtie2
  path HIV_1_Smalt
      
  output:
  tuple val(SRR), path("${SRR}_sorted.bam"), path("${SRR}_sorted.bam.bai")
      
  script:
    if( params.aligner == "bwa"){
      """
      bwa mem ${genome} ${fastq_align_1} ${fastq_align_2} \
      | samtools sort -o ${SRR}_sorted.bam | samtools index -b
      """
    }else if( params.aligner == "bowtie2"){
      """
      bowtie2 -x HIV_1 -1 ${fastq_align_1} -2 ${fastq_align_2} \
      | samtools sort -o ${SRR}_sorted.bam | samtools index -b
      """
    }else if( params.aligner == "smalt"){
      """
      smalt map -o mapped.sam HIV_1 ${fastq_align_1} ${fastq_align_2}
      samtools sort mapped.sam -o ${SRR}_sorted.bam | samtools index -b
      """
    }else{
      error "Invalid aligner"
    }
  stub:
  """
  touch ${SRR}_sorted.bam
  touch ${SRR}_sorted.bam.bai
  """
}