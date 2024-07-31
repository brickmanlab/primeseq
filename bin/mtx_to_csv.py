#!/usr/bin/env python

import argparse
import anndata
import pandas as pd
from pathlib import Path


def parse_mtx(folder: str) -> anndata.AnnData:
    """Parse StarSolo MTX count matrix

    Parameters
    ----------
    folder : str
        Path where matrix.mtx, barcodes.tsv and features.tsv are stored

    Returns
    -------
    anndata.AnnData
        Count matrix
    """
    
    adata = anndata.read_mtx(f'{folder}/matrix.mtx').T
    adata.obs_names = pd.read_table(f'{folder}/barcodes.tsv', header=None)[0]
    
    # switch gene ids for gene symbol
    genes = pd.read_table(f"{folder}/features.tsv", header=None, index_col=0)
    genes.columns = ['symbol', 'other']
    genes.index.name = 'genes'
    adata.var = genes.reset_index().set_index('symbol')
    adata.var_names_make_unique()

    return adata


def main(pool: str, solo_out: str, wells: str, barcode_plate: str):
    """Match MTX count matrix with wells from PRIME-seq

    Parameters
    ----------
    pool : str
        Name of pool (from demultiplexing, `sample` from samplesheet.csv )
    solo_out : str
        Path to Solo.out
    wells : str
        Path to wells.csv (contains the information which well is which sample)
    barcode_plate : str
        Path to barcode plate file, which has information about which barcode belongs to which well

    Raises
    ------
    IOError
        When file does not exists
    ValueError
        After pool filtering there has to be data
    """

    barcodes = pd.read_table(barcode_plate)
    folder: str = f'{solo_out}/GeneFull/filtered/'

    if not Path(folder).exists():
        raise IOError(f"Missing {folder}, aborting ...")
    
    adata = parse_mtx(folder)

    # filter wells.csv based on pool
    wells_filtered = pd.read_csv(wells).query('pool == @pool')
    if wells_filtered.empty:
        raise ValueError(f"After filtering for `{pool}`, no data were available ...")
    
    # match barcodes based on wells
    wells_filtered = wells_filtered.merge(barcodes, how='left', left_on='well', right='well')
    adata.obs = adata.obs.join(wells_filtered.set_index('barcode'))
    adata = adata[adata.obs.sort_values(by='sample').index].copy()

    # save
    adata.to_df().top_csv(f'{pool}.counts.csv')
    

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description="Generate count matrix for sample based on well and sample name")
    parser.add_argument('--version', action='version', version='1.0')
    parser.add_argument('--pool', action='store', type=str, help="Pool name")
    parser.add_argument('solo_out', action='store', type=str, help="Path to Solo.out folder")
    parser.add_argument('wells', action='store', type=str, help="Path to wells.csv")
    parser.add_argument('barcode_plate', action='store', type=str, help="Path to barcode set based on plate id")
    args = parser.parse_args()

    main(args.pool, args.solo_out, args.wells, args.barcode_plate)
