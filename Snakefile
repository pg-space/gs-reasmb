from os.path import join as pjoin

NT = workflow.cores
WD = config["wd"]
csv = config["csv"]
DATA = {}
for line in open(csv):
    pr_idx, i, sra_idx, seqt, paired = line.strip("\n").split(",")
    if paired != "PAIRED":
        continue
    DATA[sra_idx] = pr_idx

rule run:
    input:
        expand(pjoin(WD, "{pr_idx}", "{sra_idx}-shovill", "contigs.fa"),
               sra_idx=DATA.keys(),
	       pr_idx=DATA.values(),
	       product=False),

rule fetch:
    output:
        temp(pjoin(WD, "{pr_idx}", "{sra_idx}_1.fastq")),
        temp(pjoin(WD, "{pr_idx}", "{sra_idx}_2.fastq")),
    params:
        odir = pjoin(WD, "{pr_idx}"),
    log: pjoin(WD, "{pr_idx}", "{sra_idx}.log"),
    # conda: "envs/sra.yml"
    threads: NT
    shell:
        """
        fasterq-dump --split-3 --skip-technical --progress --threads 4 --temp {params.odir} --outdir {params.odir} {wildcards.sra_idx} &> {log}
        """

rule assemble:
    input:
        fq1=pjoin(WD, "{pr_idx}", "{sra_idx}_1.fastq"),
        fq2=pjoin(WD, "{pr_idx}", "{sra_idx}_2.fastq"),
    output:
        pjoin(WD, "{pr_idx}", "{sra_idx}-shovill", "contigs.fa"),
    params:
        odir=pjoin(WD, "{pr_idx}", "{sra_idx}-shovill"),
    log: pjoin(WD, "{pr_idx}", "{sra_idx}-shovill.log"),
    # conda: "envs/shovill.yml"
    threads: NT
    shell:
        """
        shovill --force --outdir {params.odir} --R1 {input.fq1} --R2 {input.fq2} --cpus {threads} &> {log}
        """
