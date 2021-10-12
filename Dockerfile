FROM ubuntu:20.04

RUN apt-get update -y \
&& apt-get install -y samtools trimmomatic  \
&& apt install -y wget \
&& apt install -y bwa \
&& apt install -y picard-tools \
&& apt install -y varscan \
&& wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.0/sratoolkit.2.8.0-ubuntu64.tar.gz \
&& tar xzvf sratoolkit.2.8.0-ubuntu64.tar.gz  --owner root --group root --no-same-owner \
&& apt install -y bowtie2 \
&& apt install -y perl \
&& apt install -y libgd-graph-perl \
&& wget https://github.com/StevenWingett/FastQ-Screen/archive/refs/tags/v0.14.1.tar.gz \
&& tar -xzf v0.14.1.tar.gz

ENV PATH="/FastQ-Screen-0.14.1/:${PATH}"
ENV PATH="/sratoolkit.2.8.0-ubuntu64/bin/:${PATH}"

ADD makeSNVlist.R /working/
ADD scriptino.R /working/
ADD FastQ-Screen/fastq-screen.conf /working/fastq-screen/
ADD FastQ-Screen/index /working/fastq-screen/index