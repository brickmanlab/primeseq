include { STARSOLO as STARSOLO_ALIGN } from '../../modules/nf-core/star/starsolo/main'

workflow STARSOLO {

    take:
    reads // channel: [ val(meta), [ fastq ] ]
    index

    main:

    ch_versions = Channel.empty()

    STARSOLO_ALIGN ( reads, index )

    ch_versions = ch_versions.mix(STARSOLO_ALIGN.out.versions.first())

    emit:
    counts      = STARSOLO_ALIGN.out.counts // channel: [ val(meta), path(Solo.out) ]
    for_multiqc = STARSOLO_ALIGN.out.log_final.map{ meta, it -> it }
    versions = ch_versions  // channel: [ versions.yml ]
}
