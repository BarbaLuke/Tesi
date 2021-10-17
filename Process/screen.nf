process Fastq_screen {
storeDir params.fastqScreenDir

  tag "${SRR}"
  
  input:
  tuple val(SRR), path(fastq)

  output:
  tuple val(SRR), path("${SRR}*screen.txt"), path("${SRR}*screen.png"), path("${SRR}*screen.html")
  tuple val("${SRR}"), path("${SRR}*.tagged_filter.fastq.gz") 

  script:
  if( params.aligner == "bwa"){
    """
    fastq_screen --conf /work/Tesi-preprocessing-docker-and-dsl2/FastQ-Screen/fastq-screen-bwa.conf --aligner bwa --tag --filter 01 ${fastq}
    """
  
  }else if( params.aligner == "bowtie2"){
    """
    fastq_screen --conf /work/Tesi-preprocessing-docker-and-dsl2/FastQ-Screen/fastq-screen-bowtie2.conf --aligner bowtie2 --tag --filter 01 ${fastq}
    """
  }else{
    error "Wrong input"
  }
  

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

process intermedi{

  input:
  tuple val(SRR), path(txt), path(png), path(html)
  
  output:
  path("fin1.txt")
  path("fin2.txt")
  
  script:
  
  if(params.library_preparation == 'single'){
  """
  tail -n +2 ${SRR}_screen.txt > temp1.txt
  head -n +3 temp1.txt > fin1.txt
  cat fin1.txt > fin2.txt
  """
  }else if(params.library_preparation == 'paired'){
  """
  tail -n +2 ${SRR}_1_screen.txt > temp1.txt
  head -n +3 temp1.txt > fin1.txt
  tail -n +2 ${SRR}_2_screen.txt > temp2.txt
  head -n +3 temp2.txt > fin2.txt
  """
  }
  

}

process Trimming_screen {

  input:
  path(file1)
  path(file2)

  output:
  stdout emit: process
  
  script:
  """
  Rscript /work/Tesi-preprocessing-docker-and-dsl2/scriptino.R -t 'fin1.txt' -b 'fin2.txt'
  """

  stub:
  """
  printf 'yes'
  """
}
