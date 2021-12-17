process Is_Paired {
    tag "${SRR}"

    input:
    val SRR

    output:
    val("${SRR}")
    path("${SRR}.txt")

    script:       
    """
    echo 'ciao' > ${SRR}.txt
    esearch -db sra -query ${SRR} | efetch -format runinfo | cut -f16 -d, | awk 'NR==2' >> ${SRR}.txt
    """

    stub:
    """
    echo PAIRED
    """
}