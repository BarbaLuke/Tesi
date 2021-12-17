process Contigs {
  tag "${SRR}"

  input:
  tuple val(SRR), path(fastq), val(paired_or_single)

  output:
  tuple val(SRR), path("MyOutputDirectory${SRR}/contigs.fasta"), val(paired_or_single), path(fastq)
  
  script:
  paired = "PAIRED"
  if(paired_or_single[0] == paired[0]){
    """
    iva -t 4 -f corr_${SRR}_1.fastq -r corr_${SRR}_2.fastq MyOutputDirectory${SRR}
    """
  }else{
    """
    iva --fr ${SRR}.fastq MyOutputDirectory${SRR}
    """   
  }

  stub:
  paired = "PAIRED"
  if(paired_or_single[0] == paired[0]){
    """
    mkdir MyOutputDirectory${SRR}
    touch MyOutputDirectory${SRR}/contigs.fasta
    """
  }else{
    """
    mkdir MyOutputDirectory${SRR}
    touch MyOutputDirectory${SRR}/contigs.fasta
    """   
  }
}