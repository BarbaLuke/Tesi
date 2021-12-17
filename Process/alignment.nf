process Alignment_and_sorting {
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq_align), val(paired_or_single)
  path (genome)
  tuple path("${genome}.amb"),
        path("${genome}.ann"),
        path("${genome}.bwt"),
        path("${genome}.fai"),
        path("${genome}.pac"),
        path("${genome}.sa")
  path HIV_1
      
  output:
  tuple val(SRR), path("${SRR}_sorted.bam"), path("${SRR}_sorted.bam.bai")
      
  script:
  paired = "PAIRED"
    if(paired_or_single[0] == paired[0]){
      if( params.aligner == "bwa"){
        """
        bwa mem ${genome} ${fastq_align} \
        | samtools sort -o ${SRR}_sorted.bam | samtools index -b
        """
      }else if( params.aligner == "bowtie2"){
        """
        bowtie2 -x HIV_1 -1 ${SRR}_align_1.fastq -2 ${SRR}_align_2.fastq \
        | samtools sort -o ${SRR}_sorted.bam | samtools index -b
        """
      }else{
        error "Wrong params for aligner"
      }
    }else{
      if( params.aligner == "bwa"){
        """
        bwa mem ${genome} ${fastq} \
        | samtools sort -o ${SRR}_sorted.bam | samtools index 
        """
      }else if( params.aligner == "bowtie2"){
        """
        bowtie2 -x HIV_1 ${fastq} | samtools sort -o ${SRR}_sorted.bam | samtools index 
        """
      }else{
        error "Wrong params for aligner"
      }
    }
  stub:
  """
  touch ${SRR}_sorted.bam
  touch ${SRR}_sorted.bam.bai
  """
}