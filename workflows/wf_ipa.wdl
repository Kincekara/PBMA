version 1.0

import "../tasks/task_lrge.wdl" as lrge
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
        input_fn: {
            description: "Input reads in FASTA, FASTQ, BAM, XML or FOFN formats.",
            patterns: ["*.bam", "*.fastq.gz", "*.fofn", "*.xml"]
        }
        genome_size: {
            description: "Estimated genome size in bp",
            patterns: ["[0-9]+"],
            optional: true
        }
        coverage: {
            description: "Downsampling target coverage",
            default: 100
        }
        advanced_options: {
            description: "Advanced options for IPA",
            optional: true,
            default: ""
        }
        no_polish: {
            description: "Skip polishing",
            optional: true,
            default: false
        }
        no_phase: { 
            description: "Skip phasing",
            optional: true,
            default: false
        }
        no_purge_dups: {
            description: "Skip purge_dups",
            optional: true,
            default: false
        }
        nthreads: {
            description: "Number of threads per sample",
            optional: true,
            default: 8
        }
    }

    input {
        String id
        File input_fn
        Int? genome_size
        Int coverage = 100
        String? advanced_options
        Boolean no_polish = false
        Boolean no_phase = false
        Boolean no_purge_dups = false
        Int nthreads = 8
    }

    if (!defined(genome_size)) {
        call lrge.estimate_genome_size {
            input:
                long_fq = input_fn
        }
    }

    call pbipa.assembly {
    input:
        id = id,
        input_fn = input_fn,
        genome_size = select_first([estimate_genome_size.est_gs, genome_size]),
        coverage = coverage,
        advanced_options = advanced_options,
        no_polish = no_polish,
        no_phase = no_phase,
        no_purge_dups = no_purge_dups,
        nthreads = nthreads
    } 

    output {
        String version = "PBMA (IPA) v0.3.0"
        File pb_final_assembly = assembly.final_assembly
        File pb_assembly_log = assembly.log
        Array[String] program_versions = [  "lrge: " + select_first([estimate_genome_size.lrge_version, "NA"]),
                                            "ipa: " + assembly.ipa_version
                                        ]
    }
}

