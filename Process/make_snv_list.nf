SNV_filters = 'PV_THR:0.01 VAR_FREQ_THR:0.05 MIN_COV:100 ALT_READ_THR:5'

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
  Rscript /work/Tesi-preprocessing-docker-and-dsl2/makeSNVlist.R "${VCFs}" "${DEPTHs}" genome.fasta ${SNV_filters}
  """

  stub:
  """
  touch SNV_list.txt
  """
} 