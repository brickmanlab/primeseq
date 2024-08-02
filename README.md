[![GitHub Actions Linting Status](https://github.com/brickmanlab/primeseq/actions/workflows/linting.yml/badge.svg)](https://github.com/brickmanlab/primeseq/actions/workflows/linting.yml)
[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.13167325-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.13167325)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A523.04.0-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/brickmanlab/primeseq)

## Introduction

**brickmanlab/primeseq** is a bioinformatics preprocessing pipeline for PRIME-seq
datasets.

1. Read QC ([`FastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))
2. Align reads using ([`StarSolo`](https://github.com/alexdobin/STAR/blob/master/docs/STARsolo.md))
3. Merge well sheet with according barcodes
4. Present QC for raw reads ([`MultiQC`](http://multiqc.info/))

## Usage

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq_1,fastq_2,plate_id
CONTROL_REP1,AEG588A1_S1_L002_R1_001.fastq.gz,AEG588A1_S1_L002_R2_001.fastq.gz,1
```

> [!WARNING]
> MAKE SURE THE `sample` (`samplesheet.csv`) is the same as `pool` (`wells.csv`)

`wells.csv`

```csv
pool,well,sample
CONTROL_REP1,A1,Sample_1
```

Each row represents paired end FASTQ reads.

Now, you can run the pipeline using:

```bash
nextflow run brickmanlab/primeseq \
    -with-tower \
    -profile ku_sund_danhead,dancmpn02fl \
    --genome GRCm39-2024-A \
    --input samplesheet.csv \
    --wells wells.csv \
    --outdir output
```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_;
> see [docs](https://nf-co.re/usage/configuration#custom-configuration-files).

## Credits

brickmanlab/primeseq was originally introduced by Nazmus Salehin and written by Martin Proks.

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

## Citations

If you use brickmanlab/primeseq for your analysis, please cite it using the following doi: [10.5281/zenodo.13167325](https://doi.org/10.5281/zenodo.13167325)

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
