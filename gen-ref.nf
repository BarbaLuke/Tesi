

process Generate_Ref_files {

  storeDir "${genomeFA.toRealPath().getParent()}"

  input:
  path genomeFA

  output:
  tuple path('*.fasta.amb'),
        path('*.fasta.ann'),
        path('*.fasta.bwt'),
        path('*.fasta.fai'),
        path('*.fasta.pac'),
        path('*.fasta.sa')

  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bwa index ${genomeFA}
  """
}