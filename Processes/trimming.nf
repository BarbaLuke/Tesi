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

trimmomatic_settings = "LEADING:$leading TRAILING:$trailing SLIDINGWINDOW:$slidingwindow MINLEN:$minlen ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:TRUE"

process Trimming {
  tag "${SRR}"

  input:
  tuple val(SRR), path(fastq)

  output:
  tuple val(SRR), path("${SRR}_out_trim_1.fastq"), path("${SRR}_out_trim_2.fastq")
  
  script:
    """
    java -jar /Trimmomatic-0.39/trimmomatic-0.39.jar PE -quiet -phred33 -validatePairs \
    ${fastq} \
    ${SRR}_out_trim_1.fastq ${SRR}_1_unpaired.trim.fastq \
    ${SRR}_out_trim_2.fastq ${SRR}_2_unpaired.trim.fastq \
    ${trimmomatic_settings}
    """

  stub:
    """
    touch ${SRR}_out_trim_1.fastq
    touch ${SRR}_out_trim_2.fastq
    """
}