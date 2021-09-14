FROM ubuntu:20.04

RUN apt-get update -y \
&& apt-get install -y samtools trimmomatic  \
&& apt install -y wget \
&& apt install -y bwa \
&& apt install -y picard-tools \
&& apt install -y varscan \
&& wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.0/sratoolkit.2.8.0-ubuntu64.tar.gz \
&& tar xzvf sratoolkit.2.8.0-ubuntu64.tar.gz  --owner root --group root --no-same-owner \
&& apt install -y bowtie2

ENV PATH="/sratoolkit.2.8.0-ubuntu64/bin/:${PATH}"
# need this script to run the last process of pipeline
ADD makeSNVlist.R /working/
# ADD reference/Reference_HIV_1(HXB2).fasta /working/