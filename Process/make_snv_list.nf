process Make_SNV_list {
  
  publishDir params.SNVlistdir, mode:'move'
  
  input:
  path "genome.fasta"
  path VCFs
  path DEPTHs
  
  output:
  path 'SNV_list.txt'
  
  script:
  """
  Rscript /working/makeSNVlist.R "${VCFs}" "${DEPTHs}" genome.fasta ${params.SNV_filters}
  """

  stub:
  """
  touch SNV_list.txt
  """
} 