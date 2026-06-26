version 1.0

task assembly {
    input {
        String id
        File bam
        String genome_size
        Boolean basemods = false
        Int cpu = 8
        String filename = basename(bam, ".bam")
    }

    command <<<
        # index file
        pbindex ~{bam}

        # create xml
        dataset create --type ConsensusReadSet ~{filename}.xml ~{bam}

        # assembly
        pbcromwell run pb_microbial_analysis \
        -e ~{filename}.xml \
        --task-option filter_min_qv=20 \
        --task-option dataset_filters="" \
        --task-option ipa2_genome_size=~{genome_size} \
        --task-option ipa2_downsampled_coverage=100 \
        --task-option ipa2_advanced_options_chrom="" \
        --task-option ipa2_advanced_options_plasmid="" \
        --task-option ipa2_cleanup_intermediate_files=True \
        --task-option microasm_plasmid_contig_len_max=300000 \
        --task-option microasm_run_secondary_polish=True \
        --task-option run_basemods=~{basemods} \
        --task-option kineticstools_identify_mods="m4C,m6A" \
        --task-option kineticstools_p_value=0.001 \
        --task-option motif_min_score=35 \
        --task-option motif_min_fraction=0.3 \
        --task-option run_find_motifs=True \
        --nproc ~{cpu} \
        --output-dir out > pbma.log

        cp out/outputs/assembly.rotated.polished.renamed.fsa ./~{id}.rotated.polished.renamed.fsa
        cp out/outputs/polished_assembly.fasta ./~{id}.polished.fasta   
    >>>

    output {
        File final_assembly = "~{id}.polished.fasta"
        File final_rotated_assembly = "~{id}.rotated.polished.renamed.fsa"
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