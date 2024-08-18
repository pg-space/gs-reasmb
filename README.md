# gs-reasmb

Scripts to re-assemble the gold standard using [shovill](https://github.com/tseemann/shovill).

### Prerequisites
``` sh
git clone https://github.com/pg-space/gs-reasmb.git
mamba create -n gs-reasmb -c conda-forge -c bioconda ncbi-datasets-cli entrez-direct sra-tools shovill snakemake-minimal
conda activate gs-reasmb
```

### HowTo
These are the steps to fetch metadata from a project, find SRA ids, download the samples (**only those tagged as PAIRED samples**), and assemble them. 

Projects:
- NCTC3000 (accession: PRJEB6403)
- GEBA (accession: PRJNA30815)
- FDA-ARGOS (accession: PRJNA231221)

``` sh
# Download all assemblies from project
datasets download genome accession PRJNA30815 --filename PRJNA30815.zip
# Extract jsonl report
unzip -p PRJNA30815.zip ncbi_dataset/data/assembly_data_report.jsonl > PRJNA30815.jsonl
# Extract SRA project ID + remove duplicates (e.g., same assembly from RefSeq and GenBank)
python3 extract_sra_idx.py PRJNA30815.jsonl | sort -u > PRJNA30815.list
# Fetch xml metadata using project id (xml files will be downloaded to the provided directory)
bash map_idx.sh PRJNA30815.list PRJNA30815
# Summarize information from xml files
python3 ~/parse_metadatas.py PRJNA30815/ > PRJNA30815.csv
# Download and assemble samples (one after the other)
snakemake [-n] -c8 --config wd="PRJNA30815-OUT" csv="PRJNA30815.csv"
```