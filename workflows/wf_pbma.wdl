version 1.0

import "../tasks/task_lrge.wdl" as lrge
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
        bam: {
            description: "PacBio HiFi reads in bam format",
            patterns: ["*.bam"]
        }
        run_basemods: {
            description: "Identify modifications using KineticTools",
            patterns: ["true", "false"],
            default: "false"
        }
        filter_min_qv: {
            description: "Minimum quality value for filtering reads",            
            patterns: ["[0-9]+"],
            default: 20 
        }
        genome_size: {
            description: "Estimated genome size",
            patterns: ["[0-9]M"],
            optional: "true"
        }
        downsampled_coverage: {
            description: "Target coverage for downsampling",
            patterns: ["[0-9]+"],
            default: 100
        }
        advanced_options_chrom: {
            description: "Advanced options for chromosomal assembly"
        }
        advanced_options_plasmid: {
            description: "Advanced options for plasmid assembly"
        }
        plasmid_contig_len_max: {
            description: "Maximum length of plasmid contigs",
            patterns: ["[0-9]+"],
            default: 300000
        }
        run_secondary_polish: {
            description: "Run secondary polishing",
            patterns: ["true", "false"],
            default: "true"
        }
        kineticstools_identify_mods: {
            description: "Modifications to identify",
            default: "m4C,m6A"
        }
        kineticstools_p_value: {
            description: "P-value threshold for modifications",
            default: 0.001
        }
        kineticstools_use_chemistry: {
            description: "Chemistry to use for modifications"
        }
        motif_min_score: {
            description: "Minimum score for motifs",
            default: 35
        }
        motif_min_fraction: {
            description: "Minimum fraction of motifs",
            default: 0.3
        }
        run_find_motifs: {
            description: "Run motif finding",
            patterns: ["true", "false"],
            default: "true"
        }
        nproc: {
            description: "Number of processors to use (per sample)",
            default: 8
        }
    }

    input {
        String id
        File bam
        Int filter_min_qv = 20 
        String? genome_size
        Boolean run_basemods = false      
        Int downsampled_coverage = 100
        String advanced_options_chrom = ""
        String advanced_options_plasmid = ""
        Int plasmid_contig_len_max = 300000
        Boolean run_secondary_polish = true
        String kineticstools_identify_mods="m4C,m6A"
        Float kineticstools_p_value = 0.001
        String kineticstools_use_chemistry=""
        Int motif_min_score = 35 
        Float motif_min_fraction = 0.3 
        Boolean run_find_motifs = true
        Int nproc = 8
    }

    if (!defined(genome_size)) {
        call lrge.estimate_genome_size {
            input:
                long_fq = bam
        }
    }

    call pbassembly.assembly {
        input:
            id = id,
            bam = bam,
            filename = basename(bam, ".bam"),              
            filter_min_qv = filter_min_qv,
            genome_size = select_first([estimate_genome_size.rounded_gs, genome_size]),
            run_basemods = run_basemods,   
            downsampled_coverage = downsampled_coverage,
            advanced_options_chrom = advanced_options_chrom,
            advanced_options_plasmid = advanced_options_plasmid,
            plasmid_contig_len_max = plasmid_contig_len_max,
            run_secondary_polish = run_secondary_polish,
            kineticstools_identify_mods = kineticstools_identify_mods,
            kineticstools_p_value = kineticstools_p_value,
            kineticstools_use_chemistry = kineticstools_use_chemistry,
            motif_min_score = motif_min_score,
            motif_min_fraction = motif_min_fraction,
            run_find_motifs = run_find_motifs,
            cpu = nproc
        } 

    output {
        String version = "PBMA v0.3.0"
        File pb_final_assembly = assembly.final_assembly
        File pb_final_rotated_assembly = assembly.final_rotated_assembly
        File pb_assembly_log = assembly.log
        Array[String] program_versions = ["lrge: " + select_first([estimate_genome_size.lrge_version,"NA"]),                                      
                                            "smrttools: " + "13.1.0.221970"
                                        ]
    }
}

