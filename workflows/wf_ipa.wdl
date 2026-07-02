version 1.0

import "../tasks/task_lrge.wdl" as lrge
import "../tasks/task_rasusa.wdl" as rasusa
import "../tasks/task_ipa.wdl" as pbipa

workflow ipa {
    meta {
        author: "Kutluhan Incekara"
        email: "kutluhan.incekara@ct.gov"
        description: "Improved Phased Assembly for HiFi reads"
    }

    parameter_meta {
        id: {
            description: "Unique identifier for the assembly"
        }
        long_fq: {
            description: "PacBio HiFi reads in bam or fastq format",
            patterns: ["*.bam", "*.fastq.gz"]
        }
    }

    input {
    String id
    File long_fq
    }

    call lrge.estimate_genome_size {
        input:
            long_fq = long_fq
    }

    call rasusa.downsample2fastq {
        input:
            id = id,
            long_fq = long_fq,
            genome_size = estimate_genome_size.rounded_gs
    }

    call pbipa.assembly {
    input:
        id = id,
        long_fq = downsample2fastq.downsampled_fastq,
        genome_size = estimate_genome_size.est_gs
    } 

    output {
        String version = "PBMA (IPA) v0.2.0"
        File pb_final_assembly = assembly.final_assembly
        File pb_assembly_log = assembly.log
        Array[String] program_versions = [  "lrge: " + estimate_genome_size.lrge_version,
                                            "rasusa: " + downsample2fastq.rasusa_version,
                                            "ipa: " + assembly.ipa_version
                                        ]
    }
}

