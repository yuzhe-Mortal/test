version 1.0 
#WORKFLOW DEFINITION
workflow CramToBamFlow{
    input {
        File ref_fasta
        File ref_fasta_index
        File ref_dict
        File input_cram
        String sample_name
        String gotc_docker = "broadinstitute/genomes-in-the-cloud:2.3.1-1500064817"
    }

 #converts CRAM to SAM to BAM and makes BAI
Call CramToTask{
    input:
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        ref_dict = ref_dict,
        input_cram = input_cram,
        sample_name = sample_name,
        docker_image = gotc_docker
#Outputs Bam, Bai, and validation report to the FireCloud data model
output {
    File outputBam = CramToBamTask.outputBam
    File outputBai = CramToBamTask.outputBai
  }
}
}
#Task Definitions
task CramToBamTask{
    input{
        #Command parameters
        File ref_fasta
        File ref_fasta_index
        File ref_dict
        File input_cram
        String sample_name

        # Runtime parameters
        Int machine_mem_size
        Int disk_size
        String docker_image
    }
#Calls samtools view to do the conversion

command {
    set -eo pipefail

    samtools view -h -T ~{ref_fasta} ~{input_cram} |
    samtools view -b -o ~{sample_name}.bam -
    samtools index -b ~{sample_name}.bam
    mv ~{sample_name}.bam.bai ~{sample_name}.bai
  }

tuntime {
    docker: docker_image
    memory: machine_mem_size + " GB"
    disks: disk_size + "GB"
#Outputs a BAM and BAI with the same sample name
output {
    File outputBam = "~{sample_name}.bam"
    File outputBai = "~{sample_name}.bai"
}

}

}







