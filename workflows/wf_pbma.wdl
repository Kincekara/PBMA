version 1.0

import "../tasks/task_lrge.wdl" as lrge
import "../tasks/task_rasusa.wdl" as rasusa
import "../tasks/task_pbassembly.wdl" as pbassembly

workflow pbma {
    meta {
        author: "Kutluhan Incekara"
        email: "kutluhan.incekara@ct.gov"
        description: "PacBio Microabial Assembly for HiFi reads"
    }

    parameter_meta {
        id: {
            description: "Unique identifier for the assembly"
        }
        long_fq: {
            description: "PacBio HiFi reads in bam or fastq format",
            patterns: [".bam", ".fastq.gz"]
        }
        basemods: {
            description: "Whether to evaluate kinetics",
            patterns: ["true", "false"],
            default: "false"
        }
    }

    input {
    String id
    File long_fq
    Boolean? basemods
    }

    call lrge.estimate_genome_size {
        input:
            long_fq = long_fq
    }

    call rasusa.downsample {
        input:
            id = id,
            long_fq = long_fq,
            genome_size = estimate_genome_size.genome_size
    }

    call pbassembly.assembly {
    input:
        id = id,
        bam = downsample.downsampled_bam,
        basemods = basemods,
        genome_size = estimate_genome_size.genome_size
    } 

    output {
        String version = "PBMA v0.1.0"
        File final_assembly = assembly.final_assembly
        File final_rotated_assembly = assembly.final_rotated_assembly
        Array[String] program_versions = [  "lrge: " + estimate_genome_size.lrge_version,
                                            "rasusa: " + downsample.rasusa_version,
                                            "smrttools: " + "13.1.0.221970"
                                        ]
    }
}

