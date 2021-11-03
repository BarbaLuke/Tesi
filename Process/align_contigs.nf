process Align_Contigs {
   tag "${SRR}"
      
    input:
    val(SRR)
    path(contigs)

    output:
    val("${SRR}") 
    path(contigs)
    path("${SRR}.blast")
    path("${SRR}_raw_wRefs.fasta")
    //path("${SRR}_cut_wRefs.fasta") optional true
  

  
    script:

    if(params.library_preparation == 'single'){
   
        """
        ./shiver-1.5.8/shiver_align_contigs.sh setting MyConfig.sh ${contigs} ${SRR}
        """

    }else{
    
        """
        ./shiver-1.5.8/shiver_align_contigs.sh setting MyConfig.sh ${contigs} ${SRR}
        """
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