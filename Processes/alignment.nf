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
  path (reference_bowtie2)
  tuple path (reference_smalt1), path (reference_smalt2)
      
  output:
  tuple val(SRR), path("${SRR}_sorted.bam"), path("${SRR}_sorted.bam.bai")
      
  script:
    if( params.aligner == "bwa"){
      if(params.deduplicate == true){
        """
        bwa mem ${genome} ${fastq_align_1} ${fastq_align_2} | samtools sort -o ${SRR}_sorted_dupli.bam
        PicardCommandLine MarkDuplicates I=${SRR}_sorted_dupli.bam O=${SRR}_sorted.bam M=${SRR}.nodup.sorted.metrics.txt REMOVE_DUPLICATES=true
        samtools index ${SRR}_sorted.bam -b
        """
      }else{
        """
        bwa mem ${genome} ${fastq_align_1} ${fastq_align_2} | samtools sort -o ${SRR}_sorted.bam
        samtools index ${SRR}_sorted.bam -b
        """
      }
    }else if( params.aligner == "bowtie2"){
      if(params.deduplicate == true){
        """
        bowtie2 -x reference -1 ${fastq_align_1} -2 ${fastq_align_2} | samtools sort -o ${SRR}_sorted_dupli.bam
        PicardCommandLine MarkDuplicates I=${SRR}_sorted_dupli.bam O=${SRR}_sorted.bam M=${SRR}.nodup.sorted.metrics.txt REMOVE_DUPLICATES=true
        samtools index ${SRR}_sorted.bam -b
        """
      }else{
        """
        bowtie2 -x reference -1 ${fastq_align_1} -2 ${fastq_align_2} | samtools sort -o ${SRR}_sorted.bam
        samtools index ${SRR}_sorted.bam -b
        """
        
      }
    }else if( params.aligner == "smalt"){
      if(params.deduplicate == true){
        """
        smalt map -o mapped.sam reference ${fastq_align_1} ${fastq_align_2}
        samtools sort mapped.sam -o ${SRR}_sorted_dupli.bam
        PicardCommandLine MarkDuplicates I=${SRR}_sorted_dupli.bam O=${SRR}_sorted.bam M=${SRR}.nodup.sorted.metrics.txt REMOVE_DUPLICATES=true
        samtools index ${SRR}_sorted.bam -b
        """
      }else{
        """
        smalt map -o mapped.sam reference ${fastq_align_1} ${fastq_align_2}
        samtools sort mapped.sam -o ${SRR}_sorted.bam
        samtools index ${SRR}_sorted.bam -b
        """
      }
    }else{
      error "Invalid aligner"
    }
  stub:
  """
  touch ${SRR}_sorted.bam
  touch ${SRR}_sorted.bam.bai
  """
}