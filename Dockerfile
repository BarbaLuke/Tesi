# at this point just a VM

FROM ubuntu:20.04
RUN apt-get update -y \
&& apt-get install -y samtools trimmomatic  \
&& apt install -y wget \
&& apt install -y bwa \
&& apt install -y picard-tools \
&& apt install -y varscan

RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.0/sratoolkit.2.8.0-ubuntu64.tar.gz
RUN tar xzvf sratoolkit.2.8.0-ubuntu64.tar.gz  --owner root --group root --no-same-owner
ENV PATH="/sratoolkit.2.8.0-ubuntu64/bin/:${PATH}"
ADD makeSNVlist.R /working/

# can't install sratoolkit couse interactive configuration

#&& wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz \
#&& tar -vxzf sratoolkit.tar.gz \
#&& echo $PATH \
#&& vdb-config --interactive-mode textual