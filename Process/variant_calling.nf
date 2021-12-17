// --min-coverage -> Minimum read depth at a position to make a call
minCoverage = '100'

// --min-var-freq -> Minimum variant allele frequency threshold
minVarFreq = '0.05'

// --p-value -> Default p-value threshold for calling variants
pValue = '0.01'

varscan_settings = "--min-coverage $minCoverage --min-var-freq $minVarFreq --p-value $pValue"

process Variant_calling{
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam), path(sorted_bam_bai)
  path (genome)
  tuple path("${genome}.amb"),
        path("${genome}.ann"),
        path("${genome}.bwt"),
        path("${genome}.fai"),
        path("${genome}.pac"),
        path("${genome}.sa")
  path HIV_1
      
  output:
  path "${SRR}.vcf"

  script:      
  """
  samtools mpileup -f ${genome} ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${varscan_settings} > ${SRR}.vcf  
  """

  stub:
  """
  touch ${SRR}.vcf
  """
}