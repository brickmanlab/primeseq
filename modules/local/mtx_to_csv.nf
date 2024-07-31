process MTX_TO_CSV {
    tag "$meta.id"
    label 'process_low'

    conda "conda-forge::scanpy conda-forge::python-igraph conda-forge::leidenalg"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/scanpy:1.7.2--pyhdfd78af_0' :
        'biocontainers/scanpy:1.7.2--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(solo_out), path(wells)

    output:
    tuple val(meta),  path('*counts.csv')        , emit: counts
    path "versions.yml"                          , emit: versions
    when:
    task.ext.when == null || task.ext.when

    script:
    def barcode_file = file("$projectDir/assets/PRIMEseq_Set${meta.plate_id}_Plate.tsv")
    """
    mtx_to_csv.py \\
        --pool $meta.id \\
        $solo_out \\
        $wells \\
        $barcode_file

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mtx_to_csv.py: \$( mtx_to_csv.py --version )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.counts.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mtx_to_csv.py: \$( mtx_to_csv.py --version )
    END_VERSIONS
    """
}
