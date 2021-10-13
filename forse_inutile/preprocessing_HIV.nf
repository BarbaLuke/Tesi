
if(file(params.FASTQ_input).isFile()) {
  SRRlist_paired = file(params.FASTQ_input).readLines()
  SRRlist_single = file(params.FASTQ_input).readLines()

  SRRnum = file(params.FASTQ_input).countLines();

  FASTQ_files_paired = Channel.empty()
  FASTQ_files_single = Channel.empty()
  params.download = false
      
}else if(file(params.FASTQ_input).isDirectory()){
  if(params.library_preparation == 'paired') {

    FASTQ_files_paired = Channel.fromFilePairs("${params.FASTQ_input}/*_{1,2}.fastq*")

    FASTQ_files_single = Channel.empty()

    SRRnum = new File(params.FASTQ_input).listFiles().count { it.name ==~ /.*1\.fastq.*/ }
  }else{
    FASTQ_files_single = Channel.fromPath("${params.FASTQ_input}/*.fastq*")
    FASTQ_files_paired = Channel.empty()
          
    SRRnum = file(params.FASTQ_input).list()((d, name) -> name.contains(".fastq")).count()
  }

  params.download = false
  SRRlist_paired = Channel.empty()
  SRRlist_single = Channel.empty()
}else{
  error "Wrong input: ${params.FASTQ_input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
}

    println """\

            VirMutSig - Preprocess pipeline    
            ================================
            SRR from: ${params.FASTQ_input}
            # of SRR: ${SRRnum}
            
            Download: ${params.download}
            Library layout: ${params.library_preparation} reads
            
            Author: Davide Maspero
            Mail: d.maspero@campus.unimib.it
            """
            .stripIndent()


genomeFAch = Channel.value(file(params.fasta))

process Generate_Ref_files {

  storeDir "${genomeFA.toRealPath().getParent()}"

  input:
  path genomeFA from genomeFAch

  output:
  path('*.fasta.fai') into genomeIndexed1
  path('HIV_1*') into genomeIndexed
  
  """
  samtools faidx ${genomeFA} -o ${genomeFA}.fai 
  bowtie2-build ${genomeFA} HIV_1
  """
}

// ############## PAIRED READS ################
process FASTQs_download_paired {

  storeDir params.FASTQdir

  tag "${SRR}" 

  input:
  val SRR from SRRlist_paired
        
  output:
  tuple val(SRR), path("${SRR}_*.fastq.gz") into FASTQ_paired

  when:
  params.library_preparation == 'paired' && params.download

  """
  fastq-dump --split-files --gzip ${SRR}
  """
}


process Trimming_paired {
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq_1_2) from FASTQ_paired.mix(FASTQ_files_paired)
      
  output:
  tuple val("${SRR}"), 
        path("${SRR}_1.trim.fastq.gz"), 
        path("${SRR}_2.trim.fastq.gz") into TRIMMED_paired
            
  when:
  params.library_preparation == 'paired'
      
  """
  TrimmomaticPE -phred33 \
  -threads ${task.cpus} \
  -summary ${SRR}.trim.summary \
  -quiet -validatePairs \
  ${fastq_1_2} \
  ${SRR}_1.trim.fastq.gz ${SRR}_1_unpaired.trim.fastq.gz \
  ${SRR}_2.trim.fastq.gz ${SRR}_2_unpaired.trim.fastq.gz \
  ${params.trimmomatic_setting}
  """
}

process Fastq_screen_paired {
  storeDir params.fastqScreenDir
  
  input:
  tuple val(SRR), path(fastq_1), path(fastq_2) from TRIMMED_paired

  output:
  tuple val(SRR), path(fastq_1), path(fastq_2) into TRIMMED_paired_post_screen
  tuple path("${SRR}_1_screen.txt"), path("${SRR}_1_screen.png"), path("${SRR}_1_screen.html") into Screen_files

  when:
  params.library_preparation == 'paired'

  """
  fastq_screen --conf /working/fastq-screen/fastq-screen.conf --aligner bwa ${fastq_1}
  """
}

process Trimming_screen_paired {

  input:
  tuple path(txt), path(png), path(html) from Screen_files

  output:
  path("procedi.txt") into Alt
  """
  tail -n +2 ${txt} > prova_1_screen_2.txt
  head -n +3 prova_1_screen_2.txt > ${txt}
  Rscript /working/scriptino.R "${txt}" > procedi.txt
  """
}
/*
process Yes_or_not {
  input:
  path(siOno) from Da_processare
  output:
  val(Si) into Facciamolo

  script:
  Si = siOno.getText()
  """
  echo ${Si}
  """

}
*/

process Alignment_and_sorting_paired {

  storeDir params.BAMdir
      
  tag "${SRR}"
      
  input:
  path(siOno) from Alt
  path "genome.fasta" from genomeFAch 
  path HIV_1 from genomeIndexed
  tuple val(SRR), path(fastq_1), path(fastq_2) from TRIMMED_paired_post_screen
      
  output:
  tuple val(SRR), path("${SRR}.sorted.bam") into SORTED_paired_depth, SORTED_paired_nodup, SORTED_paired_calling 
      
  when:
  params.library_preparation == 'paired'

  script:
  Si = siOno.getText()
      
  if(Si == "yes")
  """
  bowtie2 -x HIV_1 -1 ${fastq_1} -2 ${fastq_2} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
  else
  """
  echo "saltato"
  """
}

// ############## SINGLE READS ################

process FASTQs_download_single {

  storeDir params.FASTQdir

  tag "${SRR}" 
      
  input:
  val SRR from SRRlist_single
    
  output:
  path "${SRR}.fastq.gz" into FASTQ_single

  when:
  params.library_preparation == 'single' && params.download
      
  """
  fastq-dump --gzip ${SRR}
  """
}

process Trimming_single { 
    
  tag "${fastq.simpleName}"
      
  input:
  path fastq from FASTQ_single.mix(FASTQ_files_single)
      
  output:
  tuple val("${fastq.simpleName}"), 
        path("${fastq.simpleName}.trim.fastq.gz") into TRIMMED_single
            
  when:
  params.library_preparation == 'single'
      
  """
  TrimmomaticSE -phred33 \
  -threads ${task.cpus} \
  -summary ${fastq.simpleName}.trim.summary \
  -quiet \
  ${fastq} \
  ${fastq.simpleName}.trim.fastq.gz \
  ${params.trimmomatic_setting}
  """
}

process fastq_screen_single {
  storeDir params.fastqScreenDir
  
  input:
  tuple val(SRR), path(fastq) from TRIMMED_single

  output:
  tuple val(SRR), path(fastq) into TRIMMED_single_post_screen
  tuple path("${SRR}_screen.txt"), path("${SRR}_screen.png"), path("${SRR}_screen.html") into Screen_files

  when:
  params.library_preparation == 'single'

  """
  fastq_screen --conf /working/fastq-screen/fastq-screen.conf --aligner bwa ${fastq}
  """
}

process Trimming_screen_single {
  input:
  tuple path(txt), path(png), path(html) from Screen_files

  output:
  path("procedi.txt") into Alt
  """
  tail -n +2 ${txt} > prova_1_screen_2.txt
  head -n +3 prova_1_screen_2.txt > ${txt}
  Rscript /working/scriptino.R "${txt}" > procedi.txt
  """
}

process Alignment_and_sorting_single {

  storeDir params.BAMdir
  
  tag "${SRR}"
      
  input:
  path "genome.fasta" from genomeFAch 
      
  tuple path('genome.fasta.amb'),
        path('genome.fasta.ann'),
        path('genome.fasta.bwt'),
        path('genome.fasta.fai'),
        path('genome.fasta.pac'),
        path('genome.fasta.sa') from genomeIndexed
        
  tuple val(SRR), path(fastq) from TRIMMED_single
      
  output:
  tuple val(SRR), path("${SRR}.sorted.bam") into SORTED_single_depth, SORTED_single_nodup, SORTED_single_calling 
      
  when:
  params.library_preparation == 'single'

  script:
  Si = siOno.getText()
      
  if(Si == "yes")      
  """
  bwa mem genome.fasta \
  -t ${task.cpus} \
  ${fastq} \
  | samtools sort -@${task.cpus} -o ${SRR}.sorted.bam
  """
  else
  """
  echo "saltato"
  """
}

// ######################################################

process Remove_duplicated_reads {
      
  storeDir params.BAMdir
      
  tag "${SRR}"
    
  input:
  tuple val(SRR), path(sorted_bam) from SORTED_paired_nodup.mix(SORTED_single_nodup)
      
  output:
  tuple val(SRR), path("${SRR}.nodup.sorted.bam") into NODUP_depth, NODUP_var_call
      
  when:
  params.remove_duplicates
      
  """
  PicardCommandLine MarkDuplicates I=${sorted_bam} O=${SRR}.nodup.sorted.bam M=${SRR}.nodup.sorted.metrics.txt REMOVE_DUPLICATES=true
  """
}

process Extract_coverage_nodup {
      
  storeDir params.COVERAGEdir
      
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam) from NODUP_depth

  output: 
  path "${SRR}.depth.txt" into DEPTH_nodup

  when:
  params.remove_duplicates
      
  """
  samtools index -b ${sorted_bam}
  samtools depth -a ${sorted_bam} > ${SRR}.depth.txt
  """
}

process Extract_coverage {
      
  storeDir params.COVERAGEdir
      
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam) from SORTED_paired_depth.mix(SORTED_single_depth)

  output: 
  path "${SRR}.depth.txt" into DEPTH
      
  when:
  !params.remove_duplicates
      
  """
  samtools index -b ${sorted_bam}
  samtools depth -a ${sorted_bam} > ${SRR}.depth.txt
  """
      
}

process Variant_calling_nodup {
      
  storeDir params.VCFdir
    
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam) from NODUP_var_call
      
  path 'genome.fasta' from genomeFAch 

  path('*.fasta.fai') from genomeIndexed1
  path HIV_1 from genomeIndexed
      
  output:
  path "${SRR}.vcf" into VCF_nodup
      
  when:
  params.remove_duplicates
      
  """
  samtools mpileup -f genome.fasta ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${params.varscan} > ${SRR}.vcf  
  """
}

process Variant_calling {
      
  storeDir params.VCFdir
      
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(sorted_bam) from SORTED_paired_calling.mix(SORTED_single_calling)
      
  path "genome.fasta" from genomeFAch 
      
  path('*.fasta.fai') from genomeIndexed1
  path HIV_1 from genomeIndexed
      
  output:
  path "${SRR}.vcf" into VCF
      
  when:
  !params.remove_duplicates
      
  """
  samtools mpileup -f genome.fasta ${sorted_bam} --output sample.mpileup
  varscan pileup2snp sample.mpileup ${params.varscan} > ${SRR}.vcf  
  """
}

process make_SNV_list {
      
  publishDir params.SNVlistdir, mode:'move'
      
  input:
  path "genome.fasta" from genomeFAch 
  path VCFs from VCF.mix(VCF_nodup).collect()
  path DEPTHs from DEPTH.mix(DEPTH_nodup).collect()
      
  output:
  path 'SNV_list.txt'
      
  script:
  """
  Rscript /working/makeSNVlist.R "${VCFs}" "${DEPTHs}" genome.fasta ${params.SNV_filters}
  """
} 