version 1.0

task assembly {
    input {
        String id
        File long_fq
        Int genome_size
        Int cpu = 8
    }

    command <<<
        set -euo pipefail

        # version
        ipa --version | cut -d "=" -f2 > VERSION

        # assembly
        ipa local \
        --input-fn ~{long_fq} \
        --genome-size ~{genome_size} \
        --coverage 100 \
        --njobs 1 \
        --nthreads ~{cpu} > ~{id}.ipa_run.log

        cp ./RUN/assembly-results/final.p_ctg.fasta ./~{id}.ipa.fasta
    >>>

    output {
        String ipa_version = read_string("VERSION")
        File final_assembly = "~{id}.ipa.fasta"
        File log = "~{id}.ipa_run.log"
    }

    runtime {
        docker: "staphb/pbipa:1.8.0"
        cpu: cpu
        memory: "32 GB"
        disks: "local-disk 100 SSD"
        preemptible: 0
        maxRetries: 2
    }
}
