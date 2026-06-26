# PacBio Microbial Assembly (PBMA)

[![Dockstore](https://img.shields.io/badge/Dockstore-PBMA-blue)](https://dockstore.org/workflows/github.com/Kincekara/PBMA/PBMA)
[![Terra.bio](https://img.shields.io/badge/Terra.bio-Platform-green)](https://terra.bio/)
[![Cromwell](https://img.shields.io/badge/Cromwell-Workflow%20Engine-blue)](https://cromwell.readthedocs.io/en/stable/)
[![MiniWDL](https://img.shields.io/badge/MiniWDL-Workflow%20Engine-yellow)](https://miniwdl.readthedocs.io/en/latest/)
[![CI](https://github.com/Kincekara/PBMA/actions/workflows/check-wdl.yml/badge.svg)](https://github.com/Kincekara/PBMA/actions/workflows/check-wdl.yml)

PBMA is a WDL workflow for assembling PacBio HiFi microbial reads using the PacBio's Improved Phased Assembly (IPA2). It is designed to run microbial analysis workflow outside of the PacBio SMRT Link environment. 

The workflow performs three main steps:

1. Estimate the genome size using LRGE.
2. Downsample the input reads to a target coverage using Rasusa.
3. Assemble and polish the reads with PacBio's Microbial Analysis pipeline.

## Terra

- The pipeline is available as a [Dockstore workflow](https://dockstore.org/workflows/github.com/Kincekara/pbma/PBMA) that can be imported directly into Terra for cloud execution.

### Inputs

| Input | Type | Description |
|-------|------|-------------|
| `id` | String | Sample identifier |
| `long_fq` | File | PacBio HiFi reads (FASTQ or BAM) |
| `basemods` | Boolean | Whether to evaluate kinetics |

## Local Execution

### Requirements

- [MiniWDL](https://miniwdl.readthedocs.io/en/latest/) or [Cromwell](https://cromwell.readthedocs.io/en/latest/) installed
- A container engine (Docker, Apptainer, etc.) installed and running locally for container execution
- 8+ CPU, 32+ GB RAM, and sufficient disk space for assemblies

### Installation

```bash
git clone https://github.com/Kincekara/pbma.git
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


