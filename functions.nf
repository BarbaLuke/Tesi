def SetFastqFiles_single(input) {

    if( file(input).isFile() ){
        SRRlist_single = Channel.from(file(params.FASTQ_input).readLines())
        params.download = true
        SRRnum = file(params.FASTQ_input).countLines()
        FASTQ_files_paired = Channel.empty()
        FASTQ_files_single = Channel.empty()
    }else if( file(input).isDirectory() ){
        params.download = false
        FASTQ_files_single = Channel.fromPath("${input}/*.fastq*")
        FASTQ_files_paired = Channel.empty()
        SRRnum = file(params.FASTQ_input).list()((d, name) -> name.contains(".fastq")).count()
        SRRlist_paired = Channel.empty()
        SRRlist_single = Channel.empty()
    }else{
        error "Wrong input: ${input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
    }

}

def SetFastqFiles_paired(input) {

    if( file(input).isFile() ){
        SRRlist_paired = Channel.from(file(params.FASTQ_input).readLines())
        params.download = true
        SRRnum = file(params.FASTQ_input).countLines()
        FASTQ_files_paired = Channel.empty()
        FASTQ_files_single = Channel.empty()
    }else if( file(input).isDirectory() ){
        params.download = false
        return FASTQ_files_paired = Channel.fromFilePairs("${params.FASTQ_input}/*_{1,2}.fastq*")
        FASTQ_files_single = Channel.empty()
        return SRRnum = new File(params.FASTQ_input).listFiles().count { it.name ==~ /.*1\.fastq.*/ }
        SRRlist_paired = Channel.empty()
        SRRlist_single = Channel.empty()
    }else{
        error "Wrong input: ${params.FASTQ_input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
    }

}
