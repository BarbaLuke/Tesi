nextflow.enable.dsl=2

include { FASTQs_download } from './Processes/FASTQ-download'
include { Contigs } from './Processes/contigs'
include {  Align_Contigs; Map_Reads } from './Processes/shiver'
include { Insert_slash } from './Processes/insert'
include { Trimming } from './Processes/trimming'
include { Generate_Ref_files } from './Processes/genref'
include { Alignment_and_sorting } from './Processes/alignment'
include { Extract_coverage } from './Processes/extract_coverage'
include { Variant_calling } from './Processes/variant_calling'
include { Make_SNV_list } from './Processes/make_snv_list'

workflow {
    FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
    if(params.mode == "shiver"){
        Insert_slash(FASTQs_download.out)
        Contigs(Insert_slash.out)
        Align_Contigs(Contigs.out)
        Map_Reads(Align_Contigs.out)
    }else if(params.mode == "classic"){
        Generate_Ref_files(Channel.value(file(params.fasta)))
        Trimming(FASTQs_download.out)
        Alignment_and_sorting(Trimming.out, Channel.value(file(params.fasta)), Generate_Ref_files.out)
        extract = Extract_coverage(Alignment_and_sorting.out)
        var_call = Variant_calling(Alignment_and_sorting.out, Channel.value(file(params.fasta)))
        Make_SNV_list(Channel.value(file(params.fasta)), extract.collect(), var_call.collect())
    }else{
        error "Invalid mode"
    }
}