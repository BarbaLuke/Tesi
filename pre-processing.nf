nextflow.enable.dsl=2

include { Generate_Ref_files } from './Process/gen-ref'
include { FASTQs_download } from './Process/FASTQ-download'
include { Trimming } from './Process/trimming'
include { Fastq_screen; Trimming_screen; intermedi } from './Process/screen'
include { Alignment_and_sorting_single; Alignment_and_sorting_paired } from './Process/alignment'
include { Remove_duplicated_reads } from './Process/remove-duplicate'
include { Extract_coverage } from './Process/extract_coverage'
include { Variant_calling_bwa; Variant_calling_bowtie2 } from './Process/variant_calling'
include { Make_SNV_list } from './Process/make_snv_list'

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
    Fastq_screen(download.mix(FASTQ_files_paired))
    intermedi(Fastq_screen.out[0])
    Trimming_screen(intermedi.out)
    
    // trimming files from previous condition
    Trimming(Trimming_screen.out, Fastq_screen.out[1])

    // alignment of trimmed and checked files
    Alignment_and_sorting_single(Channel.value(file(params.fasta)), index_bwa, index_bowtie2, Trimming.out[0])

    emit:
    Alignment_and_sorting_single.out
}

workflow paired {
    take: index_bwa
     index_bowtie2

    main:
    // condition to enable download or not 
    if( file(params.FASTQ_input).isFile() ){
        download = FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
        FASTQ_files_paired = Channel.empty()

    }else if( file(params.FASTQ_input).isDirectory() ){
        FASTQ_files_paired = Channel.fromFilePairs("${params.FASTQ_input}/*_{1,2}.fastq*")
        SRRnum = new File(params.FASTQ_input).listFiles().count { it.name ==~ /.*1\.fastq.*/ }
        download = Channel.empty()

    }else{
        error "Wrong input: ${params.FASTQ_input}. It must be a .txt file with a SRR number on each line or a directory with the fastq files." 
    }

    // FastQ-Screen contamination checks
    Fastq_screen(download.mix(FASTQ_files_paired))
    intermedi(Fastq_screen.out[0])
    Trimming_screen(intermedi.out)
    
    // trimming files from previous condition
    Trimming(Trimming_screen.out, Fastq_screen.out[1])

    // alignment of trimmed and checked files
    Alignment_and_sorting_paired(Channel.value(file(params.fasta)), index_bwa, index_bowtie2, Trimming.out[1])

    emit:
    Alignment_and_sorting_paired.out
}

workflow {

    Generate_Ref_files(Channel.value(file(params.fasta)))

    // single or paired
    if(params.library_preparation == 'single'){
        sin = single(Generate_Ref_files.out[0], Generate_Ref_files.out[1])
        pair = Channel.empty()
        
    }else{
        pair = paired(Generate_Ref_files.out[0], Generate_Ref_files.out[1])
        sin = Channel.empty()
    }

    // remove duplicates or not
    if(params.remove_duplicates){
        Remove_duplicated_reads(pair.mix(sin))
        extract_dupli = Extract_coverage(Remove_duplicated_reads.out)

        // bowtie or bwa
        if(params.aligner == "bowtie2"){
            variant_dupli =Variant_calling_bowtie2(Remove_duplicated_reads.out, Channel.value(file(params.fasta)), Generate_Ref_files.out[2], Generate_Ref_files.out[1])
        }else if(params.aligner == "bwa"){
            variant_dupli = Variant_calling_bwa(Remove_duplicated_reads.out, Channel.value(file(params.fasta)), Generate_Ref_files.out[0], Generate_Ref_files.out[2])
        }else{
            error "Wrong input: ${params.aligner}. It must be bowtie2 or bwa." 
        }
        extract = Channel.empty()
        variant = Channel.empty()
    }else{
        extract = Extract_coverage(pair.mix(sin))

        // bowtie or bwa
        if(params.aligner == "bowtie2"){
            variant = Variant_calling_bowtie2(pair.mix(sin), Channel.value(file(params.fasta)), Generate_Ref_files.out[2], Generate_Ref_files.out[1])
        }else if(params.aligner == "bwa"){
            variant = Variant_calling_bwa(pair.mix(sin), Channel.value(file(params.fasta)), Generate_Ref_files.out[0], Generate_Ref_files.out[2])
        }else{
            error "Wrong input: ${params.aligner}. It must be bowtie2 or bwa." 
        }
        extract_dupli = Channel.empty()
        variant_dupli = Channel.empty()
    }
    // script to get snv_list.txt
    Make_SNV_list(Channel.value(file(params.fasta)), variant.mix(variant_dupli).collect(), extract.mix(extract_dupli).collect())
}
