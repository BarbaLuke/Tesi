process Decontaminate_from_Human {
  tag "${SRR}"

  input:
  tuple val(SRR), path(fastq_align_1), path(fastq_align_2)
  tuple path(human_genome), path(ref)

  output:
  tuple val(SRR), path("${SRR}_out_trim_decont_1.fastq"), path("${SRR}_out_trim_decont_2.fastq")
  
  script:
    """
    bbsplit.sh in1=${fastq_align_1} in2=${fastq_align_2} ref=${ref} basename=out_%.fastq out1=${SRR}_out_trim_decont_1.fastq out2=${SRR}_out_trim_decont_2.fastq
    """

  stub:
    """
    touch ${SRR}_out_trim_decont_1.fastq
    touch ${SRR}_out_trim_decont_2.fastq
    """
}