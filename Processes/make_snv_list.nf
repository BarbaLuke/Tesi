SNV_filters = 'PV_THR:0.01 VAR_FREQ_THR:0.05 MIN_COV:100 ALT_READ_THR:5'

process Make_SNV_list {
  
  input:
  path (genome)
  path VCFs
  path DEPTHs
  
  output:
  path 'SNV_list.txt'
  
  script:
  """
  Rscript makeSNVlist.R "${VCFs}" "${DEPTHs}" ${genome} ${SNV_filters}
  """

  stub:
  """
  touch SNV_list.txt
  """
} 

process Make_SNV_list_SHIVER {
  
  input:
  path (genome)
  path CSV
  
  output:
  path 'SNV_list.txt'
  
  script:
  """
  Rscript makeSNVlistSHIVER.R
  """

  stub:
  """
  touch SNV_list.txt
  """
}