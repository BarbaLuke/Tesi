process Fastq_screen{
    tag "${SRR}"

    input:
    tuple val(SRR), path(fastq), val(paired_or_single)
     
    output:
    tuple val(SRR), path("${SRR}_out_trim*.tagged_filter.fastq"), val(paired_or_single)
    tuple val(SRR), path("${SRR}_out_trim*.fals.fastq"), val(paired_or_single)
    tuple val(SRR), path(fastq), val(paired_or_single)
    tuple val(SRR), path("${SRR}_out_trim*screen.txt"), path("${SRR}_out_trim*screen.png"), path("${SRR}_out_trim*screen.html")

    script:
    paired = "PAIRED"
    if(paired_or_single[0] == paired[0]){
      if( params.aligner == "bwa"){
        """
        fastq_screen --conf /FastQ-Screen/fastq-screen-bwa.conf --inverse --aligner bwa --tag --filter 3- ${fastq}
        touch ${SRR}_out_trim_1.fals.fastq
        touch ${SRR}_out_trim_2.fals.fastq
        """
      }else if( params.aligner == "bowtie2"){
        """
        fastq_screen --conf /FastQ-Screen/fastq-screen-bowtie2.conf --inverse --aligner bowtie2 --tag --filter 3- ${fastq}
        touch ${SRR}_out_trim_1.fals.fastq
        touch ${SRR}_out_trim_2.fals.fastq
        """
      }else{
        error "Wrong params for aligner"
      }
    }else{
      if( params.aligner == "bwa"){
        """
        fastq_screen --conf /FastQ-Screen/fastq-screen-bwa.conf --inverse --aligner bwa --tag --filter 3- ${fastq}
        touch ${SRR}_out_trim.fals.fastq
        """
      }else if( params.aligner == "bowtie2"){
        """
        fastq_screen --conf /FastQ-Screen/fastq-screen-bowtie2.conf --inverse --aligner bowtie2 --tag --filter 3- ${fastq}
        touch ${SRR}_out_trim.fals.fastq
        """
      }else{
        error "Wrong params for aligner"
      }
    }
    stub:
    paired = "PAIRED"
    if(paired_or_single[0] == paired[0]){
      """
      touch ${SRR}_out_trim_1.tagged_filter.fastq
      touch ${SRR}_out_trim_2.tagged_filter.fastq
      touch ${SRR}_out_trim_1.fals.fastq
      touch ${SRR}_out_trim_2.fals.fastq
      touch ${SRR}_out_trim_1.screen.txt
      touch ${SRR}_out_trim_1.screen.png
      touch ${SRR}_out_trim_1.screen.html
      touch ${SRR}_out_trim_2.screen.txt
      touch ${SRR}_out_trim_2.screen.png
      touch ${SRR}_out_trim_2.screen.html
      touch ${SRR}_out_trim_1.fastq
      touch ${SRR}_out_trim_2.fastq
      """
    }else{
      """
      touch ${SRR}_out_trim.tagged_filter.fastq
      touch ${SRR}_out_trim.fals.fastq
      touch ${SRR}_out_trim.screen.txt
      touch ${SRR}_out_trim.screen.png
      touch ${SRR}_out_trim.screen.html
      touch ${SRR}_out_trim.fastq
      """
    }
}