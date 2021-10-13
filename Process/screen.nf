process Fastq_screen {
  tag "${SRR}"
  
  input:
  tuple val(SRR), path(fastq)

  output:
  tuple val(SRR), path("${SRR}_1.trim_screen.txt"), path("${SRR}_1.trim_screen.png"), path("${SRR}_1.trim_screen.html") optional true
  tuple val(SRR), path("${SRR}.trim_screen.txt"), path("${SRR}.trim_screen.png"), path("${SRR}.trim_screen.html") optional true

  script:
  if( params.aligner == "bwa")
  """
  fastq_screen --conf /FastQ-Screen/fastq-screen.conf --aligner bwa ${fastq}
  """
  if( params.aligner == "bowtie2")
  """
  fastq_screen --conf /FastQ-Screen/fastq-screen.conf --aligner bowtie2 ${fastq}
  """

  stub:
  if( params.library_preparation == 'single' ){
    """
    touch ${SRR}.trim_screen.txt
    touch ${SRR}.trim_screen.png
    touch ${SRR}.trim_screen.html
    """
  }else{
    """
    touch ${SRR}_1.trim_screen.txt
    touch ${SRR}_1.trim_screen.png
    touch ${SRR}_1.trim_screen.html
    """
  }
}

process Trimming_screen {
  tag "${SRR}"

  input:
  tuple val(SRR), path(txt), path(png), path(html)

  output:
  stdout emit: process
  
  script:
  """
  tail -n +2 ${txt} > prova_1_screen_2.txt
  head -n +3 prova_1_screen_2.txt > prova_1_screen_3.txt
  Rscript /scriptino.R -t "prova_1_screen_3.txt" 
  """

  stub:
  """
  printf 'yes'
  """
}