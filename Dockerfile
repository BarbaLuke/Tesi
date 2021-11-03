FROM ubuntu:20.04

ADD MyConfig.sh /
ADD reference/HIV_1.fasta /
ADD reference/MyAdapters.fasta /
ADD reference/MyPrimers.fasta /

RUN DEBIAN_FRONTEND="noninteractive" apt-get update -y \
&& DEBIAN_FRONTEND="noninteractive" apt update -y \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y python-dev \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y python3-dev \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y ncbi-blast+ \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y bc \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y wget \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y unzip\
#&& DEBIAN_FRONTEND="noninteractive" apt-get install -y samtools trimmomatic  \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y samtools \
&& wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip \
&& unzip Trimmomatic-0.39.zip \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y mafft \
&& DEBIAN_FRONTEND="noninteractive" apt install -y curl \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python2 \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y python3 \
&& DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y \
&& DEBIAN_FRONTEND="noninteractive" apt upgrade -y \
&& DEBIAN_FRONTEND="noninteractive" apt install -y python3-pip \
&& curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py \
&& python get-pip.py \
&& pip install --upgrade pip \
&& DEBIAN_FRONTEND="noninteractive" apt install -y git \
&& pip3 install pyfastaq \
&& pip install NumPy \
&& pip install biopython==1.67 \
#&& DEBIAN_FRONTEND="noninteractive" apt install -y bwa \
&& DEBIAN_FRONTEND="noninteractive" apt install -y picard-tools \
&& DEBIAN_FRONTEND="noninteractive" apt install -y varscan \
&& DEBIAN_FRONTEND="noninteractive" apt install -y nano\
&& Rscript -e "install.packages('optparse')"\
&& wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.0/sratoolkit.2.8.0-ubuntu64.tar.gz \
&& tar xzvf sratoolkit.2.8.0-ubuntu64.tar.gz  --owner root --group root --no-same-owner \
&& DEBIAN_FRONTEND="noninteractive" apt install -y bowtie2 \
&& DEBIAN_FRONTEND="noninteractive" apt install -y perl \
&& DEBIAN_FRONTEND="noninteractive" apt install -y libgd-graph-perl \
&& wget https://github.com/StevenWingett/FastQ-Screen/archive/refs/tags/v0.14.1.tar.gz \
&& tar -xzf v0.14.1.tar.gz \
&& curl -s https://get.nextflow.io | bash \
&& wget https://altushost-swe.dl.sourceforge.net/project/bbmap/BBMap_38.94.tar.gz \
&& tar -xzf BBMap_38.94.tar.gz \
#&& DEBIAN_FRONTEND="noninteractive" apt install -y python-pip \
#&& wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.12.0+-x64-linux.tar.gz \
#&& tar -xzf ncbi-blast-2.12.0+-x64-linux.tar.gz \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y zlib1g-dev libbz2-dev liblzma-dev \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y bc \
&& DEBIAN_FRONTEND="noninteractive" apt-get install -y iva \
&& apt-get install -y smalt \
&& curl -s https://get.nextflow.io | bash \
&& pip3 install packaging \
&& wget https://github.com/ChrisHIV/shiver/archive/refs/tags/v1.5.8.tar.gz \
&& tar -xvzf v1.5.8.tar.gz \
&& mkdir setting \
&& ./shiver-1.5.8/shiver_init.sh setting MyConfig.sh HIV_1.fasta MyAdapters.fasta MyPrimers.fasta
#&& wget https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 \
#&& tar -xjf samtools-1.6.tar.bz2 \
#&& cd samtools-1.6/ \
#&& ./configure \
#&& make \
#&& make install \
#&& wget https://mafft.cbrc.jp/alignment/software/mafft-7.313-without-extensions-src.tgz \
#&& tar -xzf mafft-7.313-without-extensions-src.tgz \
#&& cd mafft-7.313-without-extensions/core/ \
#&& make clean \
#&& make \
#&& make install \
#&& DEBIAN_FRONTEND="noninteractive" apt-get install -y default-jre \
#&& wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip \
#&& unzip Trimmomatic-0.36.zip \
#&& wget https://sourceforge.net/projects/smalt/files/latest/download -O smalt.tgz \
#&& tar -xzf smalt.tgz \
#&& cd smalt-0.7.6/ \
#&& ./configure \
#&& make \
#&& make install 
#&& git clone https://github.com/lh3/bwa.git \
#&& cd bwa \
#&& make \
#&& wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.3.1/bowtie2-2.3.3.1-linux-x86_64.zip/download -O bowtie2.zip \ 
#&& unzip bowtie2.zip

ENV PATH="/FastQ-Screen-0.14.1/:${PATH}"
#ENV PATH="/ncbi-blast-2.7.1+/bin/:${PATH}"
ENV PATH="/sratoolkit.2.8.0-ubuntu64/bin/:${PATH}"
ENV PATH="/nextflow/:${PATH}"
ENV PATH="/bbmap/:${PATH}"
ENV PATH="/Trimmomatic-0.39/:${PATH}"
#ENV PATH="/samtools-1.6/:${PATH}"
#ENV PATH="/bwa/:${PATH}"
#ENV PATH="/bowtie2-2.3.3.1-linux-x86_64/:${PATH}"
ENV PATH="/nextflow/:${PATH}"