version 1.0

task estimate_genome_size {
    input {
        File long_fq
        Int cpu = 4
    }

    command <<<
        set -euo pipefail

        # version 
        lrge --version | cut -d " " -f2 > VERSION

        # find genome size
        lrge \
        -P pb \
        -t ~{cpu} \
        -o gsize.txt \
        ~{long_fq}   

        # rounded integer
        printf "%d\n" $(( ($(cat gsize.txt) +500000)/1000000 * 1000000 )) > GSIZE

        # rounded string
        printf "%dM\n" $(( ($(cat gsize.txt) +500000)/1000000 )) > SGSIZE
    >>>

    output {
        String lrge_version = read_string("VERSION")
        File lrge_gs = "gsize.txt"
        Int est_gs = read_int("GSIZE")
        String rounded_gs = read_string("SGSIZE")
    }

    runtime {
        docker: "staphb/lrge:0.3.0"
        cpu: cpu
        memory: "8 GiB"
        disks: "local-disk 50 HDD"
        preemptible: 0
        maxRetries: 3
    }
}