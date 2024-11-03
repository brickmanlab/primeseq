include { STARSOLO as STARSOLO_ALIGN } from '../../modules/nf-core/star/starsolo/main'

workflow STARSOLO {

    take:
    reads // channel: [ val(meta), [ fastq ] ]
    index // channel [ val(meta), [starindex] ]
    whitelist // file [whitelist]

    main:

    ch_versions = Channel.empty()

    ch_reads = reads.map {
        meta, fastq -> [
            [
                id: meta.id,
                plate_id: meta.plate_id,
                umi_len: 16,
                umi_start: 13,
                cb_len: 12,
                cb_start: 1,
            ], "CB_UMI_Simple", fastq
        ]
    }

    STARSOLO_ALIGN ( ch_reads, whitelist, index )

    ch_versions = ch_versions.mix(STARSOLO_ALIGN.out.versions.first())

    emit:
    counts      = STARSOLO_ALIGN.out.counts // channel: [ val(meta), path(Solo.out) ]
    for_multiqc = STARSOLO_ALIGN.out.log_final.map{ meta, it -> it }
    versions = ch_versions  // channel: [ versions.yml ]
}
