version 1.0

task assembly {
    input {
        String id
        File input_fn
        Int genome_size
        Int coverage
        String? advanced_options
        Boolean no_polish
        Boolean no_phase
        Boolean no_purge_dups
        Int nthreads
    }

    command <<<
        set -euo pipefail

        ext_args=""
        if ~{no_polish}; then ext_args+=" --no-polish"; fi
        if ~{no_phase}; then ext_args+=" --no-phase"; fi
        if ~{no_purge_dups}; then ext_args+=" --no-purge-dups"; fi
        echo "additional argumants = $ext_args"

        # version
        ipa --version | cut -d "=" -f2 > VERSION

        # assembly
        ipa local \
        --input-fn ~{input_fn} \
        --genome-size ~{genome_size} \
        --coverage ~{coverage} \
        --njobs 1 \
        --nthreads ~{nthreads} \
        ~{'--advanced-opt ' + advanced_options} \
        $ext_args > ~{id}.ipa_run.log

        cp ./RUN/assembly-results/final.p_ctg.fasta ./~{id}.ipa.fasta
    >>>

    output {
        String ipa_version = read_string("VERSION")
        File final_assembly = "~{id}.ipa.fasta"
        File log = "~{id}.ipa_run.log"
    }

    runtime {
        docker: "staphb/pbipa:1.8.0"
        cpu: nthreads
        memory: "32 GB"
        disks: "local-disk 100 SSD"
        preemptible: 0
        maxRetries: 1
    }
}
