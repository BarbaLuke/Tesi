nextflow.enable.dsl=2

include { FASTQs_download } from './Processes/FASTQ-download'
include { Contigs } from './Processes/contigs'
include {  Align_Contigs; Map_Reads } from './Processes/shiver'
include { Insert_slash } from './Processes/insert'

workflow {
    FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
    if(params.mode == "shiver"){
        Insert_slash(FASTQs_download.out)
        Contigs(Insert_slash.out)
        Align_Contigs(Contigs.out)
        Map_Reads(Align_Contigs.out)
    }else if(params.mode == "classic"){

    }else{
        error "Invalid mode"
    }
}