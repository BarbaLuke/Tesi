// questo deve essere inserito in prima posizione
nextflow.enable.dsl=2

include { Generate_Ref_files_screen; Downloading_human_genome; Generate_Ref_files_human } from './Process/gen-ref'



workflow {

    Downloading_human_genome()

    Generate_Ref_files_human(Downloading_human_genome.out)

    Generate_Ref_files_screen(Channel.value(file(params.fasta)))

}