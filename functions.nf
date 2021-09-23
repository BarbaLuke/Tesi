def SetFastqFiles(download) {


    if(params.library_preparation == 'single' && params.download == true && file(params.FASTQ_input).isFile()){
        SRRnum = file(params.FASTQ_input).countLines()
        FASTQ_files_paired = Channel.empty()
        FASTQ_files_single = Channel.empty()
    }else if(params.library_preparation == 'paired' && params.download == true && file(params.FASTQ_input).isFile()){
        SRRnum = file(params.FASTQ_input).countLines()
        FASTQ_files_paired = Channel.empty()
        FASTQ_files_single = Channel.empty()
    }else if(params.download == false && file(params.FASTQ_input).isDirectory() && params.library_preparation == 'paired'){
        FASTQ_files_paired = Channel.fromFilePairs("${params.FASTQ_input}/*_{1,2}.fastq*")
        FASTQ_files_single = Channel.empty()
        SRRnum = new File(params.FASTQ_input).listFiles().count { it.name ==~ /.*1\.fastq.*/ }
        SRRlist_paired = Channel.empty()
        SRRlist_single = Channel.empty()
    }else if(params.download == false && file(params.FASTQ_input).isDirectory() && params.library_preparation == 'single'){
        FASTQ_files_single = Channel.fromPath("${params.FASTQ_input}/*.fastq*")
        FASTQ_files_paired = Channel.empty()
        SRRnum = file(params.FASTQ_input).list()((d, name) -> name.contains(".fastq")).count()
        SRRlist_paired = Channel.empty()
        SRRlist_single = Channel.empty()
    }else{
        error "Wrong input: ${params.FASTQ_input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
    }

}
