process FAST_qc {
    tag "${SRR}"

    input:
    tuple val(SRR), path(fastq), val(paired_or_single)

    output:
    tuple path("${SRR}*_fastqc.html"), path("${SRR}*_fastqc.zip")
       
    script:
    """
    fastqc ${fastq}
    """

    stub:
    paired = "PAIRED"
    if(paired_or_single[0] == paired[0]){
        """
        #!/bin/sh
        touch ${SRR}_1.fastqc.html
        touch ${SRR}_2.fastqc.html
        touch ${SRR}_1.fastqc.zip
        touch ${SRR}_2.fastqc.zip
        """
    }else{
        """
        #!/bin/sh
        touch ${SRR}.fastqc.html
        touch ${SRR}.fastqc.zip
        """
    }
}