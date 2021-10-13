process Fastq_screen {
  tag "${SRR}"
  
  input:
  tuple val(SRR), path(fastq)

  output:
  tuple path("${SRR}_1.trim_screen.txt"), path("${SRR}_1.trim_screen.png"), path("${SRR}_1.trim_screen.html") optional true
  tuple path("${SRR}.trim_screen.txt"), path("${SRR}.trim_screen.png"), path("${SRR}.trim_screen.html") optional true

  script:
  if( params.aligner == "bwa")
  """
  fastq_screen --conf /fastq-screen.conf --aligner bwa ${fastq}
  """
  if( params.aligner == "bowtie2")
  """
  fastq_screen --conf /fastq-screen.conf --aligner bowtie2 ${fastq}
  """
}

process Trimming_screen {
  input:
  tuple path(txt), path(png), path(html)

  output:
  stdout emit: process
  
  script:

  """
  tail -n +2 ${txt} > prova_1_screen_2.txt
  head -n +3 prova_1_screen_2.txt > prova_1_screen_3.txt
  Rscript /working/scriptino.R -t "prova_1_screen_3.txt" 
  """
}