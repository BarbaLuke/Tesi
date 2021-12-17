process Align_Contigs {
    tag "${SRR}"
      
    input:
    tuple val(SRR), path(contigs), val(paired_or_single), path(fastq)

    output:
    tuple val(SRR), path("${SRR}.blast"), path("${SRR}_raw_wRefs.fasta"), path("${SRR}_cut_wRefs.fasta"), path(contigs), path(fastq)
  
    script:
    aligner = params.shiver_align
    paired = "PAIRED"
    if(paired_or_single[0] == paired[0]){
        """
        /shiver-1.5.8/shiver_align_contigs.sh /setting_${aligner} /MyConfig_${aligner}.sh ${contigs} ${SRR}
        if [ -e ${SRR}_cut_wRefs.fasta ]; then
            
        else
            touch ${SRR}_cut_wRefs.fasta
        fi
        """
    }else{
        error "Data must be paired-end to be processed by SHIVER"
    }

    stub:
    paired = "PAIRED"
    if(paired_or_single[0] == paired[0]){
        """
        touch ${SRR}.blast
        touch ${SRR}_raw_wRefs.fasta
        touch ${SRR}_cut_wRefs.fasta
        """
    }else{
        error "Data must be paired-end to be processed by SHIVER"
    }
}

//######################################################################################################################
process Map_Reads {
    tag "${SRR}"

    input:
    tuple val(SRR), path(blast), path(raw), path(cut), path(contigs), path(fastq)

    output:
    tuple val(SRR), path("${SRR}.sorted.bam"), path("${SRR}.bam.bai")
    
    script:
    aligner = params.shiver_align
    """
    if [ -s ${cut} ]; then
        /shiver-1.5.8/shiver_map_reads.sh /setting_${aligner} /MyConfig_${aligner}.sh ${contigs} ${SRR} \
        ${blast} ${cut} ${fastq}
    else
        /shiver-1.5.8/shiver_map_reads.sh /setting_${aligner} /MyConfig_${aligner}.sh ${contigs} ${SRR} \
        ${blast} ${raw} ${fastq}
    fi
    samtools sort -o ${SRR}.sorted.bam ${SRR}.bam
    """

    stub:
    """
    touch ${SRR}.sorted.bam
    touch ${SRR}.bam.bai
    """
}