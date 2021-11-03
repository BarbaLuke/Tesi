process Map_Reads {
    tag "${SRR}"

    input:
    val(SRR)
    path(contigs)
    path(fastq)
    path(blast)
    //path(cut)
    path(raw)

    output:
    val("${SRR}")
    path("${SRR}.bam")
  
    script:

    if(params.library_preparation == 'single'){
        //cut.ifEmpty('Hello')
        //if(cut == 'Hello'){
            """
            ./shiver-1.5.8/shiver_map_reads.sh setting MyConfig.sh ${contigs} ${SRR} \
            ${blast} ${raw} ${fastq}
            """
       // }else{
       //     """
       //     ./shiver-1.5.8/shiver_map_reads.sh setting MyConfig.sh ${contigs} ${SRR} \
       //    ${blast} ${cut} ${fastq}
       //     """
       // }
    }else{
        //cut.ifEmpty('Hello')
       //if(cut == 'Hello'){
            """
            gunzip ${fastq}
            awk '{if (NR%4 == 1) {print $1 $2 $3 "/1"} else print}' ${SRR} _1.fastq > corr_${SRR} _1.fastq
            awk '{if (NR%4 == 1) {print $1 $2 $3 "/2"} else print}' ${SRR} _2.fastq > corr_${SRR} _2.fastq
            ./shiver-1.5.8/shiver_map_reads.sh setting MyConfig.sh ${contigs} ${SRR} \
            ${blast} ${raw} corr_${SRR} _1.fastq corr_${SRR} _2.fastq
            """ 
       // }else{
       //     """
       //     ./shiver-1.5.8/shiver_map_reads.sh setting MyConfig.sh ${contigs} ${SRR} \
       //     ${blast} ${cut} ${fastq}
       //     """
       // }
  }

  stub:

  if(params.library_preparation == 'single'){     
    """
    touch ${SRR}.trim.fastq.gz
    """
  }else{
    """
    touch ${SRR}_1.trim.fastq.gz
    touch ${SRR}_2.trim.fastq.gz
    """
  }
}