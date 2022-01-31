nextflow.enable.dsl=2

include { FASTQs_download } from './Processes/FASTQ-download'
include { Contigs } from './Processes/contigs'
include { Align_Contigs; Map_Reads } from './Processes/shiver'
include { Insert_slash } from './Processes/insert'
include { Trimming } from './Processes/trimming'
include { Generate_Ref_files; Download_Human_Genome } from './Processes/genref'
include { Alignment_and_sorting } from './Processes/alignment'
include { Extract_coverage } from './Processes/extract_coverage'
include { Variant_calling } from './Processes/variant_calling'
include { Make_SNV_list; Make_SNV_list_SHIVER } from './Processes/make_snv_list'
include { Decontaminate_from_Human } from './Processes/decontaminate'

if(params.shiver == "local" && params.mode == "shiver"){
    shiver_dir = Channel.value(file( 'shiver-1.5.8' , type: 'dir', checkIfExists: true))
    setting_dir = Channel.value(file( 'shiver_settings', type: 'dir', checkIfExists: true ))
}else{
    shiver_dir = Channel.value(file( '/shiver-1.5.8' , type: 'dir'))
    setting_dir = Channel.value(file( '/shiver_settings', type: 'dir'))
}
human_genome_link = Channel.value( 'https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz' )
workflow {
    FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
    if(params.mode == "shiver"){
        Insert_slash(FASTQs_download.out)
        Contigs(Insert_slash.out)
        Align_Contigs(Contigs.out, shiver_dir, setting_dir)
        Map_Reads(Align_Contigs.out, shiver_dir, setting_dir)
        Make_SNV_list_SHIVER(Channel.value(file('makeSNVlistSHIVER.R')), Channel.value(file(params.fasta)), Map_Reads.out[2].collect())
    }else if(params.mode == "classic"){
        Generate_Ref_files(Channel.value(file(params.fasta)))
        Download_Human_Genome(human_genome_link)
        Trimming(FASTQs_download.out)
        if(params.decontaminate == true){
            Decontaminate_from_Human(Trimming.out, Download_Human_Genome.out)
            Alignment_and_sorting(Decontaminate_from_Human.out, Channel.value(file(params.fasta)), Generate_Ref_files.out)
        }else{
            Alignment_and_sorting(Trimming.out, Channel.value(file(params.fasta)), Generate_Ref_files.out)
        }
        extract = Extract_coverage(Alignment_and_sorting.out)
        var_call = Variant_calling(Alignment_and_sorting.out, Channel.value(file(params.fasta)))
        Make_SNV_list(Channel.value(file(params.fasta)), var_call.collect(), extract.collect())
    }else{
        error "Invalid mode"
    }
}