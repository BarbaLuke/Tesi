process Setting_shiver {

    input:
    path(shiver)
    path(genomeFA)
    path(config_bowtie)
    path(config_bwa)
    path(config_smalt)
    path(adapters)
    path(primers)

    output:
    tuple path("setting_bowtie2"), path("setting_bwa"), path("setting_smalt")

    script:
    """
    ${shiver}/shiver_init.sh setting_bowtie2 ${config_bowtie} ${genomeFA} ${adapters} ${primers} 
    ${shiver}/shiver_init.sh setting_bwa ${config_bwa} ${genomeFA} ${adapters} ${primers}
    ${shiver}/shiver_init.sh setting_smalt ${config_smalt} ${genomeFA} ${adapters} ${primers}
    """
}

process Align_Contigs {
    tag "${SRR}"
      
    input:
    tuple val(SRR), path(contigs), path(fastq)
    path(config)
    path(config_dir)

    output:
    tuple val(SRR), path("${SRR}.blast"), path("${SRR}_raw_wRefs.fasta"), path("${SRR}_cut_wRefs.fasta"), path(contigs), path(fastq)
  
    script:
    """
    /shiver-1.5.8/shiver_align_contigs.sh ${config_dir} ${config} ${contigs} ${SRR}
    if [ -e ${SRR}_cut_wRefs.fasta ]; then
        touch ciao.txt
    else
        touch ${SRR}_cut_wRefs.fasta
    fi
    """

    stub:
    """
    touch ${SRR}.blast
    touch ${SRR}_raw_wRefs.fasta
    touch ${SRR}_cut_wRefs.fasta
    """
}
//######################################################################################################################
process Map_Reads {
    tag "${SRR}"

    input:
    tuple val(SRR), path(blast), path(raw), path(cut), path(contigs), path(fastq)
    path(config)
    path(config_dir)

    output:
    tuple val(SRR), path("${SRR}.sorted.bam"), path("${SRR}_remap.bam.bai")
    path("${SRR}_consensus_MinCov_15_30_ForGlobalAln.fasta")
    path("${SRR}_BaseFreqs_WithHXB2.csv")
    path("${SRR}_InsertSizeCounts.csv")
    path("${SRR}_consensus_MinCov_15_30.fasta")
    path("${SRR}_BaseFreqs.csv")
    
    script:
    """
    if [ -s ${cut} ]; then
        /shiver-1.5.8/shiver_map_reads.sh ${config_dir} ${config} ${contigs} ${SRR} ${blast} ${cut} ${fastq}
    else
        /shiver-1.5.8/shiver_map_reads.sh ${config_dir} ${config} ${contigs} ${SRR} ${blast} ${raw} ${fastq}
    fi
    samtools sort -o ${SRR}.sorted.bam ${SRR}.bam
    """

    stub:
    """
    touch ${SRR}_BaseFreqs.csv
    touch ${SRR}_consensus_MinCov_15_30.fasta
    touch ${SRR}_InsertSizeCounts.csv
    touch ${SRR}_BaseFreqs_WithHXB2.csv
    touch ${SRR}_consensus_MinCov_15_30_ForGlobalAln.fasta
    touch ${SRR}_remap.bam.bai
    touch ${SRR}.sorted.bam
    touch ${SRR}.bam.bai
    """
}