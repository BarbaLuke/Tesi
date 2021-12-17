process Repair {  
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq_trim), val(paired_or_single)
  tuple val(SRR2), path(fastq_screen), val(paired_or_single2)

  output: 
  tuple val(SRR), path("${SRR}_align*.fastq"), val(paired_or_single) optional true
  tuple val(SRR), path("${SRR}_shiver*.fastq"), val(paired_or_single) optional true

  script:  
  paired = "PAIRED"
  if(paired_or_single[0] == paired[0]){
    """
    repair.sh in1=${SRR}_out_trim_1.fastq in2=${SRR}_out_trim_2.fastq out1=${SRR}_shiver_1.fastq out2=${SRR}_shiver_2.fastq outs=unpaired_shiver_${SRR}.fastq repair
    """
  }else{
    """
    mv ${SRR}_out_trim.tagged_filter.fastq ${SRR}_align.fastq
    """
  }

  stub:
  paired = "PAIRED"
  if(paired_or_single[0] == paired[0]){
    """
    touch ${SRR}_align_1.fastq
    touch ${SRR}_align_2.fastq
    touch ${SRR}_shiver_1.fastq
    touch ${SRR}_shiver_2.fastq
    """
  }else{
    """
    touch ${SRR}_align.fastq
    """
  }
}