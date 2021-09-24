// questo deve essere inserito in prima posizione
nextflow.enable.dsl=2

include { Generate_Ref_files } from './gen-ref'
include { SetFastqFiles_paired; SetFastqFiles_single } from './functions'
include { FASTQs_download_paired; FASTQs_download_single } from './FASTQ-download'
include { Trimming_single; Trimming_paired } from './trimming'

// provo a generare due workflow differenti per il preprocessing per il paired o single
workflow single {

    SetFastqFiles_single(params.FASTQ_input)

    if( params.download == true ){
        FASTQs_download_single(Channel.from(file(params.FASTQ_input).readLines()))
        Trimming_single(FASTQs_download_single.out)
    }else{

    }
    
}

workflow paired {

    SetFastqFiles_paired(params.FASTQ_input)

    if( params.download == true ){
        FASTQs_download_paired(Channel.from(file(params.FASTQ_input).readLines()))
        Trimming_paired(FASTQs_download_paired.out)
    }else{
        
    }
    

}

workflow {

    Generate_Ref_files(Channel.value(file(params.fasta)))
    
    if(params.library_preparation == 'single'){
        single()

    }else{
        paired()
    }
}