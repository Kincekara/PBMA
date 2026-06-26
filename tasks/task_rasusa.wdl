version 1.0

task downsample {
    input {
        String id
        File long_fq
        String genome_size
    }

    command <<<
        set -euo pipefail

        # version 
        rasusa --version | cut -d " " -f2 > VERSION
        
        # downsample reads
        rasusa reads \
        --seed 42 \
        --coverage 110 \
        --genome-size ~{genome_size} \
        --output ~{id}.downsampled.bam \
        --output-format bam \
        ~{long_fq}
    >>>

    output {
        String rasusa_version = read_string("VERSION")
        File downsampled_bam = "~{id}.downsampled.bam"
    }

    runtime {
        docker: "staphb/rasusa:4.1.0"
        cpu: 2
        memory: "2 GiB"
        preemptible: 0
        maxRetries: 3
    }
}

