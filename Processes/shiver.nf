process Align_Contigs {
tag "${SRR}"

    input:
    tuple val(SRR), path(contigs), path(fastq)
    path(shive)
    path(setting_dir)

    output:
    tuple val(SRR), path("${SRR}.blast"), path("${SRR}_raw_wRefs.fasta"), path("${SRR}_cut_wRefs.fasta"), path(contigs), path(fastq)

    script:
    if(params.aligner == "bowtie2"){
        """
        ${shive}/shiver_align_contigs.sh ${setting_dir}/setting_bowtie2 ${setting_dir}/MyConfig_bowtie2.sh ${contigs} ${SRR}
        if [ -e ${SRR}_cut_wRefs.fasta ]; then
        touch ciao.txt
        else
        touch ${SRR}_cut_wRefs.fasta
        fi
        """
    }else if(params.aligner == "bwa"){
        """
        ${shive}/shiver_align_contigs.sh ${setting_dir}/setting_bwa ${setting_dir}/MyConfig_bwa.sh ${contigs} ${SRR}
        if [ -e ${SRR}_cut_wRefs.fasta ]; then
        touch ciao.txt
        else
        touch ${SRR}_cut_wRefs.fasta
        fi
        """
    }else if(params.aligner == "smalt"){
        """
        ${shive}/shiver_align_contigs.sh ${setting_dir}/setting_smalt ${setting_dir}/MyConfig_smalt.sh ${contigs} ${SRR}
        if [ -e ${SRR}_cut_wRefs.fasta ]; then
        touch ciao.txt
        else
        touch ${SRR}_cut_wRefs.fasta
        fi
        """
    }else{
        error "Invalid Aligner"

    }

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
    path(shive)
    path(setting_dir)


    output:
    tuple val(SRR), path("${SRR}.sorted.bam"), path("${SRR}_remap.bam.bai")
    path("${SRR}_consensus_MinCov_15_30_ForGlobalAln.fasta")
    path("${SRR}_BaseFreqs_WithHXB2.csv")
    path("${SRR}_InsertSizeCounts.csv")
    path("${SRR}_consensus_MinCov_15_30.fasta")
    path("${SRR}_BaseFreqs.csv")
    
    script:
    if(params.aligner == "bowtie2"){
        """
        if [ -s ${cut} ]; then
        ${shive}/shiver_map_reads.sh  ${setting_dir}/setting_bowtie2 ${setting_dir}/MyConfig_bowtie2.sh ${contigs} ${SRR} ${blast} ${cut} ${fastq}
        else
        ${shive}/shiver_map_reads.sh  ${setting_dir}/setting_bowtie2 ${setting_dir}/MyConfig_bowtie2.sh ${contigs} ${SRR} ${blast} ${raw} ${fastq}
        fi
        samtools sort -o ${SRR}.sorted.bam ${SRR}.bam
        """
    }else if(params.aligner == "bwa"){
        """
        if [ -s ${cut} ]; then
        ${shive}/shiver_map_reads.sh  ${setting_dir}/setting_bwa ${setting_dir}/MyConfig_bwa.sh ${contigs} ${SRR} ${blast} ${cut} ${fastq}
        else
        ${shive}/shiver_map_reads.sh  ${setting_dir}/setting_bwa ${setting_dir}/MyConfig_bwa.sh ${contigs} ${SRR} ${blast} ${raw} ${fastq}
        fi
        samtools sort -o ${SRR}.sorted.bam ${SRR}.bam
        """
    }else if(params.aligner == "smalt"){
        """
        if [ -s ${cut} ]; then
        ${shive}/shiver_map_reads.sh  ${setting_dir}/setting_smalt ${setting_dir}/MyConfig_smalt.sh ${contigs} ${SRR} ${blast} ${cut} ${fastq}
        else
        ${shive}/shiver_map_reads.sh  ${setting_dir}/setting_smalt ${setting_dir}/MyConfig_smalt.sh ${contigs} ${SRR} ${blast} ${raw} ${fastq}
        fi
        samtools sort -o ${SRR}.sorted.bam ${SRR}.bam
        """
    }else{
        error "Invalid aligner"

    }

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