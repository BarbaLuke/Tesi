nextflow.enable.dsl=2

include { Generate_Ref_files } from './Process/gen-ref'
include { FASTQs_download } from './Process/FASTQ-download'
include { Trimming } from './Process/trimming'
include { Contigs } from './Process/contigs'
include { Align_Contigs } from './Process/align_contigs'
include { Map_Reads } from './Process/map_reads'
include { Fastq_screen; Trimming_screen; intermedi } from './Process/screen'
include { Alignment_and_sorting } from './Process/alignment'
include { Remove_duplicated_reads } from './Process/remove-duplicate'
include { Extract_coverage } from './Process/extract_coverage'
include { Variant_calling } from './Process/variant_calling'
include { Make_SNV_list } from './Process/make_snv_list'
include { Repair } from './Process/repair'
/*
workflow single {
    take: index_bwa
    index_bowtie2

    main:
    // condition to enable download or not 
    if( file(params.FASTQ_input).isFile() ){
        download = FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
        FASTQ_files_single = Channel.empty()

    }else if( file(params.FASTQ_input).isDirectory() ){
        FASTQ_files_single = Channel.fromPath("${params.FASTQ_input}/*.fastq*")
        SRRnum = file(params.FASTQ_input).list()((d, name) -> name.contains(".fastq")).count()
        download = Channel.empty()

    }else{
        error "Wrong input: ${params.FASTQ_input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
    }

    // FastQ-Screen contamination checks
    Fastq_screen(download.mix(FASTQ_files_single))
    intermedi(Fastq_screen.out[0], Fastq_screen.out[1])
    Trimming_screen(intermedi.out)
    
    // trimming files from previous condition
    Trimming(Trimming_screen.out, Fastq_screen.out[0], Fastq_screen.out[2])

    // alignment of trimmed and checked files
    Alignment_and_sorting_single(Channel.value(file(params.fasta)), index_bwa, index_bowtie2, Trimming.out[0], Trimming.out[1])
    
    emit:
    Alignment_and_sorting_single.out[0]
    Alignment_and_sorting_single.out[1]
}*/

workflow paired {

    main:
    download = FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
    // condition to enable download or not 
    /*
    if( file(params.FASTQ_input).isFile() ){
        
        FASTQ_files_paired = Channel.empty()

    }else if( file(params.FASTQ_input).isDirectory() ){
        FASTQ_files_paired = Channel.fromFilePairs("${params.FASTQ_input}/*_{1,2}.fastq*")
        download = Channel.empty()

    }else{
        error "Wrong input: ${params.FASTQ_input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
    }
    */

    // FastQ-Screen contamination checks
    Contigs(download)

    /*Fastq_screen(Trimming.out[0], Trimming.out[1])
    
    //intermedi(Fastq_screen.out[0], Fastq_screen.out[1])
    //Trimming_screen(intermedi.out)
    
    // trimming files from previous condition
    

    // repair fastq paired end 
    Repair(Fastq_screen.out[0], Fastq_screen.out[2])

    // alignment of trimmed and checked files
    Alignment_and_sorting(Channel.value(file(params.fasta)), index_bwa, index_bowtie2, Repair.out[0], Repair.out[1])*/
    
    emit:
    Contigs.out[0]
    Contigs.out[1]
}

workflow {

    //Generate_Ref_files(Channel.value(file(params.fasta)))

    //paired()
    FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
    Contigs(FASTQs_download.out[0], FASTQs_download.out[1])
    Align_Contigs(Contigs.out[0], Contigs.out[1])
    Map_Reads(Align_Contigs.out[0], Contigs.out[2], FASTQs_download.out[2], Align_Contigs.out[2], Align_Contigs.out[3])

/*
    // remove duplicates or not
    if(params.remove_duplicates){
        Remove_duplicated_reads(paired.out[0], paired.out[1])
        extract_dupli = Extract_coverage(Remove_duplicated_reads.out)
        variant_dupli = Variant_calling(Remove_duplicated_reads.out, Channel.value(file(params.fasta)), Generate_Ref_files.out[0], Generate_Ref_files.out[1])
        extract = Channel.empty()
        variant = Channel.empty()
    }else{
        extract = Extract_coverage(paired.out[0], paired.out[1])
        variant = Variant_calling(paired.out[0], paired.out[1], Channel.value(file(params.fasta)), Generate_Ref_files.out[2], Generate_Ref_files.out[3])
        extract_dupli = Channel.empty()
        variant_dupli = Channel.empty()
    }
    // script to get snv_list.txt
    Make_SNV_list(Channel.value(file(params.fasta)), variant.mix(variant_dupli).collect(), extract.mix(extract_dupli).collect())
    */
}