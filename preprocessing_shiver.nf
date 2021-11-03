nextflow.enable.dsl=2

include { Generate_Ref_files } from './Process/gen-ref'
include { FASTQs_download } from './Process/FASTQ-download'
include { Contigs } from './Process/contigs'
include { Align_Contigs } from './Process/align_contigs'
include { Map_Reads } from './Process/map_reads'
include { Extract_coverage } from './Process/extract_coverage'
include { Variant_calling } from './Process/variant_calling'
include { Make_SNV_list } from './Process/make_snv_list'

workflow {

    Generate_Ref_files(Channel.value(file(params.fasta)))
    FASTQs_download(Channel.from(file(params.FASTQ_input).readLines()))
    Contigs(FASTQs_download.out[0], FASTQs_download.out[1])
    Align_Contigs(Contigs.out[0], Contigs.out[1])
    Map_Reads(Align_Contigs.out[0], Contigs.out[2], FASTQs_download.out[2], Align_Contigs.out[2], Align_Contigs.out[3])
    extract = Extract_coverage(Map_Reads.out[0], Map_Reads.out[1])
    variant = Variant_calling(Map_Reads.out[0], Map_Reads.out[1], Channel.value(file(params.fasta)), Generate_Ref_files.out[2], Generate_Ref_files.out[3])
    Make_SNV_list(Channel.value(file(params.fasta)), variant.collect(), extract.collect())

}