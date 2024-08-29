#Remove low quality reads from fastq files downloaded from SRA
for file in *.fastq.gz; do trim_galore $file; done

#Align trimmed fastq files to the Arabidopsis genome (TAIR10)
for file in *.fq.gz; do bowtie2 -x /path/to/TAIR10 -U $file -S "`basename $file _trimmed.fq.gz`.sam"; done

#Convert SAM files to BAM files and remove SAM files (primarily for storage purposes)
for file in *.sam; do samtools view -S -b $file > "`basename $file .sam`_original.bam"
for file in *.sam; do rm $file; done

#Coordinate sort BAM files and remove original BAM files 
##Original [name-sorted] BAM or SAM files if needed using SAMtools
for file in *_original.bam; do samtools sort -o "`basename $file _original.bam`_final.bam" $file 
for file in *_original.bam; do rm $file; done


#Convert BAM files to bedgraph for further processing in R
for file in *final.bam; do bamCoverage -b $file -o "`basename $file final.bam`black.bg" -of bedgraph -bs 1 -bl blacklist.bed --effectiveGenomeSize 119482012 --normalizeUsing RPGC; done

##Note: Let's convert this to Nextflow to speed this process up