version 1.0

task assembly {
    input {
        String id
        File bam
        String filename
        Int filter_min_qv
        String genome_size
        Boolean run_basemods   
        Int downsampled_coverage
        String advanced_options_chrom
        String advanced_options_plasmid
        Int plasmid_contig_len_max
        Boolean run_secondary_polish
        String kineticstools_identify_mods
        Float kineticstools_p_value
        String kineticstools_use_chemistry
        Int motif_min_score
        Float motif_min_fraction
        Boolean run_find_motifs
        Int cpu
    }

    command <<<
        # index file
        pbindex ~{bam}

        # create xml
        dataset create --type ConsensusReadSet ~{filename}.xml ~{bam}

        # assembly
        pbcromwell run pb_microbial_analysis \
        -e ~{filename}.xml \
        --task-option filter_min_qv=~{filter_min_qv} \
        --task-option dataset_filters="" \
        --task-option ipa2_genome_size=~{genome_size} \
        --task-option ipa2_downsampled_coverage=~{downsampled_coverage} \
        --task-option ipa2_advanced_options_chrom=~{advanced_options_chrom} \
        --task-option ipa2_advanced_options_plasmid=~{advanced_options_plasmid} \
        --task-option ipa2_cleanup_intermediate_files=True \
        --task-option microasm_plasmid_contig_len_max=~{plasmid_contig_len_max} \
        --task-option microasm_run_secondary_polish=~{run_secondary_polish} \
        --task-option run_basemods=~{run_basemods} \
        --task-option kineticstools_identify_mods=~{kineticstools_identify_mods} \
        --task-option kineticstools_p_value=~{kineticstools_p_value} \
        --task-option kineticstools_use_chemistry=~{kineticstools_use_chemistry} \
        --task-option motif_min_score=~{motif_min_score} \
        --task-option motif_min_fraction=~{motif_min_fraction} \
        --task-option run_find_motifs=~{run_find_motifs} \
        --nproc ~{cpu} \
        --output-dir out > ~{id}.pbma.log

        cp out/outputs/assembly.rotated.polished.renamed.fsa ./~{id}.rotated.polished.renamed.fsa
        cp out/outputs/polished_assembly.fasta ./~{id}.polished.fasta   
    >>>

    output {
        File final_assembly = "~{id}.polished.fasta"
        File final_rotated_assembly = "~{id}.rotated.polished.renamed.fsa"
        File log = "~{id}.pbma.log"
    }

    runtime {
        docker: "kincekara/smrttools:sequel2-13.1"
        cpu: cpu
        memory: "32 GB"
        disks: "local-disk 100 SSD"
        preemptible: 0
        maxRetries: 2
    }
}