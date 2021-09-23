// questo deve essere inserito in prima posizione
nextflow.enable.dsl=2

// parametro per settare il download o meno
params.download = true

include { Generate_Ref_files } from './gen-ref'
include { SetFastqFiles } from './functions'
include { FASTQs_download_paired; FASTQs_download_single } from './FASTQ-download'

// provo a generare due workflow differenti per il preprocessing per il paired o single
workflow single {

    SetFastqFiles(params.download)

    if(params.download == true && file(params.FASTQ_input).isFile()){
        FASTQs_download_single(Channel.from(file(params.FASTQ_input).readLines()))
    }
}

workflow paired {

    SetFastqFiles(params.download)

    if(params.download == true && file(params.FASTQ_input).isFile()){
        FASTQs_download_paired(Channel.from(file(params.FASTQ_input).readLines()))
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