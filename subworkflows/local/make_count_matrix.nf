include { MTX_TO_CSV } from '../../modules/local/mtx_to_csv'

workflow MAKE_COUNT_MATRIX {

    take:
    reads // channel: [ val(meta), path(solo_out), path(wells) ]

    main:

    ch_versions = Channel.empty()

    MTX_TO_CSV ( reads )
    
    ch_versions = ch_versions.mix(MTX_TO_CSV.out.versions.first())

    emit:
    counts   = MTX_TO_CSV.out.counts // channel: [ val(meta), path(csv) ]
    versions = ch_versions  // channel: [ versions.yml ]
}
