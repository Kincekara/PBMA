# PacBio Microbial Assembly (PBMA)

[![Dockstore](https://img.shields.io/badge/Dockstore-PBMA-blue)](https://dockstore.org/workflows/github.com/Kincekara/PBMA/PBMA)
[![Terra.bio](https://img.shields.io/badge/Terra.bio-Platform-green)](https://terra.bio/)
[![Cromwell](https://img.shields.io/badge/Cromwell-Workflow%20Engine-blue)](https://cromwell.readthedocs.io/en/stable/)
[![MiniWDL](https://img.shields.io/badge/MiniWDL-Workflow%20Engine-yellow)](https://miniwdl.readthedocs.io/en/latest/)
[![CI](https://github.com/Kincekara/PBMA/actions/workflows/check-wdl.yml/badge.svg)](https://github.com/Kincekara/PBMA/actions/workflows/check-wdl.yml)

PBMA is a WDL workflow for assembling PacBio HiFi microbial reads using the PacBio's Improved Phased Assembly (IPA2). It is designed to run microbial analysis workflow outside of the PacBio SMRT Link environment. 

The workflow performs two main steps:

1. If not provided, estimate the genome size using LRGE.
3. Assemble and polish the reads with PacBio's Microbial Analysis pipeline.

## Terra

- The [PBMA](https://dockstore.org/workflows/github.com/Kincekara/PBMA/PBMA) pipeline is available in Dockstore as a that can be imported directly into Terra for cloud execution.

- The alternative workflow [IPA](https://dockstore.org/workflows/github.com/Kincekara/PBMA/IPA) for fastq input files is also available in Dockstore.
### PBMA Inputs

| Input | Type | Description | Default |
|-------|------|-------------|---------|
| `id` | String | Sample identifier |  |
| `bam` | File | PacBio HiFi reads |  |
| `run_basemods` | Boolean | Whether to evaluate kinetics | false |
| `filter_min_qv` | Int | Minimum quality value for filtering reads | 20 |
| `genome_size` | String | Estimated genome size | null (find automatically)|
| `downsampled_coverage` | Int | Target coverage for downsampling | 100 |
| `advanced_options_chrom` | String | Advanced options for chromosomal assembly | "" |
| `advanced_options_plasmid` | String | Advanced options for plasmid assembly | "" |
| `plasmid_contig_len_max` | Int | Maximum length of plasmid contigs | 300000 |
| `run_secondary_polish` | Boolean | Whether to run secondary polishing | true |
| `kineticstools_identify_mods` | String | Modifications to identify | "m4C,m6A" |
| `kineticstools_p_value` | Float | P-value threshold for modifications | 0.001 |
| `kineticstools_use_chemisty` | String | chemistry information | "" |
| `motif_min_score` | Int | Minimum score for motifs | 35 |
| `motif_min_fraction` | Float | Minimum fraction of motifs | 0.3 |
| `run_find_motifs` | Boolean | Whether to run motif finding | true |
| `nproc` | Int | Number of processors to use (per sample) | 8 |

> [!NOTE]
> The `run_basemods` parameter is only applicable to the PBMA workflow. PBMA only accepts BAM input files, while the IPA workflow accepts different file formats. 

## Local Execution

### Requirements

- [MiniWDL](https://miniwdl.readthedocs.io/en/latest/) or [Cromwell](https://cromwell.readthedocs.io/en/latest/) installed
- A container engine (Docker, Apptainer, etc.) installed and running locally for container execution
- 8+ CPU, 32+ GB RAM, and sufficient disk space for assemblies

### Installation

```bash
git clone https://github.com/Kincekara/PBMA.git
```

### Single Sample Assembly

```bash
miniwdl run /path/to/pbma/workflows/wf_pbma.wdl \
  id=sample1 \
  long_fq=sample1.hifi.bam

```

## Outputs

| Output | Description |
|------|-------------|
| `final_assembly` | Final polished assembly|
| `final_rotated_assembly` | Rotated and renamed polished assembly|

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Support

For questions or issues, please open an issue on GitHub.


