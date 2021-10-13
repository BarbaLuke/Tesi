// Cut bases off the start of a read, if below a threshold quality
// LEADING:<quality> 
leading = '25'

// Cut bases off the end of a read, if below a threshold quality
// TRAILING:<quality> 
trailing = '25'

// Perform a sliding window trimming, cutting once the average quality within the window falls below a threshold.
// SLIDINGWINDOW:<windowSize>:<requiredQuality> 
slidingwindow = '1:25'

// Drop the read if it is below a specified length
// MINLEN:<length> 
minlen = '75'

trimmomatic_settings = 'LEADING:$leading TRAILING:$trailing SLIDINGWINDOW:$slidingwindow MINLEN:$minlen'

process Trimming {
  tag "${SRR}"
      
  input:
  tuple val(SRR), path(fastq)

  output:
  tuple val("${SRR}"), path("${SRR}.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_1.trim.fastq.gz"), path("${SRR}_2.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_1.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}.trim.fastq.gz") optional true
  tuple val("${SRR}"), path("${SRR}_1.trim.fastq.gz"), path("${SRR}_2.trim.fastq.gz") optional true  

  script:

  if(params.library_preparation == 'single'){
                
    """
    TrimmomaticSE -phred33 \
    -threads ${task.cpus} \
    -summary ${SRR}.trim.summary \
    -quiet \
    ${fastq} \
    ${SRR}.trim.fastq.gz \
    ${trimmomatic_settings}
    """

  }else{
    
    """
    TrimmomaticPE -phred33 \
    -threads ${task.cpus} \
    -summary ${SRR}.trim.summary \
    -quiet -validatePairs \
    ${fastq} \
    ${SRR}_1.trim.fastq.gz ${SRR}_1_unpaired.trim.fastq.gz \
    ${SRR}_2.trim.fastq.gz ${SRR}_2_unpaired.trim.fastq.gz \
    ${trimmomatic_settings}
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