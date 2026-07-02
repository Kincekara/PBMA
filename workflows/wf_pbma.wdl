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
            description: "PacBio HiFi reads in bam format",
            patterns: ["*.bam"]
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

    call rasusa.downsample2bam {
        input:
            id = id,
            long_fq = long_fq,
            genome_size = estimate_genome_size.rounded_gs
    }

    call pbassembly.assembly {
    input:
        id = id,
        bam = downsample2bam.downsampled_bam,
        basemods = basemods,
        genome_size = estimate_genome_size.rounded_gs
    } 

    output {
        String version = "PBMA v0.2.0"
        File pb_final_assembly = assembly.final_assembly
        File pb_final_rotated_assembly = assembly.final_rotated_assembly
        File pb_assembly_log = assembly.log
        Array[String] program_versions = [  "lrge: " + estimate_genome_size.lrge_version,
                                            "rasusa: " + downsample2bam.rasusa_version,
                                            "smrttools: " + "13.1.0.221970"
                                        ]
    }
}

