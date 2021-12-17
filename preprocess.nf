nextflow.enable.dsl=2

include { Generate_Ref_files } from './Process/gen-ref'
include { Is_Paired } from './Process/is_paired'
include { FASTQs_download } from './Process/FASTQ-download'
include { FAST_qc } from './Process/FAST-qc'
include { Trimming } from './Process/trimming'
include { Repair} from './Process/repair'
include { Contigs } from './Process/contigs'
include { Align_Contigs; Map_Reads } from './Process/shiver'
include { Fastq_screen } from './Process/fastq-screen'
include { Alignment_and_sorting } from './Process/alignment'
include { Insert_slash } from './Process/insert'
include { Make_SNV_list } from './Process/make_snv_list'
include { Variant_calling } from './Process/variant_calling'
include { Extract_coverage } from './Process/extract_coverage'

workflow {
    Generate_Ref_files(Channel.value(file(params.fasta)))
    Is_Paired(Channel.from(file(params.FASTQ_input).readLines()))
    FASTQs_download(Is_Paired.out)
    /*Insert_slash(FASTQs_download.out)
    Contigs(Insert_slash.out)
    Align_Contigs(Contigs.out)
    Map_Reads(Align_Contigs.out)
    extract = Extract_coverage(Map_Reads.out)
    variant = Variant_calling(Map_Reads.out, Channel.value(file(params.fasta)), Generate_Ref_files.out[0], Generate_Ref_files.out[1])
    Make_SNV_list(Channel.value(file(params.fasta)), extract.collect(), variant.collect())*/
}