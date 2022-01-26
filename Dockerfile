FROM ubuntu:20.04

ADD shiver_settings/MyConfig_bowtie2.sh /
ADD shiver_settings/MyConfig_bwa.sh /
ADD shiver_settings/MyConfig_smalt.sh /
ADD reference/HIV_1.fasta /
ADD reference/MyAdapters.fasta /
ADD reference/MyPrimers.fasta /
ADD makeSNVlist.R /
ADD makeSNVlistSHIVER.R /

RUN DEBIAN_FRONTEND="noninteractive" apt-get update -y \
&& DEBIAN_FRONTEND="noninteractive" apt update -y \
## sample tools need for ubuntu
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y wget \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y unzip \
&& DEBIAN_FRONTEND="noninteractive" apt install -y curl \
## get META from NCBI samples (not yet)
##&& DEBIAN_FRONTEND="noninteractive" apt install -y ncbi-entrez-direct \
## get quality report (not yet)
##&& DEBIAN_FRONTEND="noninteractive" apt install -y fastqc \
## need for SHIVER
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y python-dev \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y python3-dev \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y ncbi-blast+ \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y bc \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y mafft \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y iva \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python2 \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y python3 \
&& DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y \
&& DEBIAN_FRONTEND="noninteractive" apt upgrade -y \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python3-pip \
&& pip3 install packaging \
&& curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py \
&& python get-pip.py \
&& pip install --upgrade pip \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python3-pip \
&& DEBIAN_FRONTEND="noninteractive" apt install -y git \
&& pip3 install pyfastaq \
&& pip install NumPy \
&& pip install biopython==1.67 \
&& wget https://github.com/ChrisHIV/shiver/archive/refs/tags/v1.5.8.tar.gz \
&& tar -xvzf v1.5.8.tar.gz \
&& mkdir -p shiver_settings \
&& mkdir -p shiver_settings/setting_bowtie2 \
&& mkdir -p shiver_settings/setting_bwa \
&& mkdir -p shiver_settings/setting_smalt \
&& cp MyConfig_bowtie2.sh shiver_settings \
&& cp MyConfig_bwa.sh shiver_settings \
&& cp MyConfig_smalt.sh shiver_settings \
&& ./shiver-1.5.8/shiver_init.sh shiver_settings/setting_bowtie2 shiver_settings/MyConfig_bowtie2.sh HIV_1.fasta MyAdapters.fasta MyPrimers.fasta \
&& ./shiver-1.5.8/shiver_init.sh shiver_settings/setting_bwa shiver_settings/MyConfig_bwa.sh HIV_1.fasta MyAdapters.fasta MyPrimers.fasta \
&& ./shiver-1.5.8/shiver_init.sh shiver_settings/setting_smalt shiver_settings/MyConfig_smalt.sh HIV_1.fasta MyAdapters.fasta MyPrimers.fasta \
## need for align sorting
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y samtools \
## need for trimming
&& wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip \
&& unzip Trimmomatic-0.39.zip \
## need for Re-Pair reads from decontamination or trimming (not yet)
##&& wget https://altushost-swe.dl.sourceforge.net/project/bbmap/BBMap_38.94.tar.gz \
##&& tar -xzf BBMap_38.94.tar.gz \
## need to align
&& DEBIAN_FRONTEND="noninteractive" apt install -y bowtie2 \
&& DEBIAN_FRONTEND="noninteractive" apt install -y bwa \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y smalt \
## need for decontamination using FASTQ-SCREEN (not yet)
##&& DEBIAN_FRONTEND="noninteractive" apt install -y perl \
##&& DEBIAN_FRONTEND="noninteractive" apt install -y libgd-graph-perl \
##&& DEBIAN_FRONTEND="noninteractive" apt-get install -y zlib1g-dev libbz2-dev liblzma-dev \
##&& wget https://github.com/StevenWingett/FastQ-Screen/archive/refs/tags/v0.14.1.tar.gz \
##&& tar -xzf v0.14.1.tar.gz \
##&& mkdir FastQ-Screen \
##&& mkdir FastQ-Screen/index \
##&& mkdir FastQ-Screen/index/hiv \
##&& mkdir FastQ-Screen/index/human \
##&& mkdir FastQ-Screen/index/hiv/bowtie2 \
##&& mkdir FastQ-Screen/index/human/bwa \
##&& mkdir FastQ-Screen/index/hiv/bwa \
##&& mkdir FastQ-Screen/index/human/bowtie2 \
## need for VCF
&& DEBIAN_FRONTEND="noninteractive" apt install -y picard-tools \
&& DEBIAN_FRONTEND="noninteractive" apt install -y varscan \
## need to download fastq sample from SRA archives in NCBI
&& wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.0/sratoolkit.2.8.0-ubuntu64.tar.gz \
&& tar xzvf sratoolkit.2.8.0-ubuntu64.tar.gz  --owner root --group root --no-same-owner \
## installing packages for R script
&& Rscript -e "install.packages('seqinr')"\
&& Rscript -e "install.packages('foreach')"\
&& Rscript -e "install.packages('doFuture')"


ENV PATH="/FastQ-Screen-0.14.1/:${PATH}"
ENV PATH="/bbmap/:${PATH}"
ENV PATH="/Trimmomatic-0.39/:${PATH}"
ENV PATH="/nextflow/:${PATH}"
ENV PATH="/sratoolkit.2.8.0-ubuntu64/bin/:${PATH}"

## COMMAND TO RUN ONLY IN GIACINTO
##ARG USER_ID
##ARG GROUP_ID

##RUN addgroup --gid $GROUP_ID user
##RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
##USER user