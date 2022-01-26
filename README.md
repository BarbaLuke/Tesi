# Preprocessing for Mutational signatures (via Docker)
Re-styling preprocessing for [VirMutSig](https://github.com/BIMIB-DISCo/VirMutSig) using Docker for HIV.

## Technologies
***
* [Nextflow](https://www.nextflow.io/)
* [Docker](https://www.docker.com/)
* [Shiver](https://github.com/ChrisHIV/shiver)
## Prerequisites
***
### Essential:
* Nextflow prerequisites (see [quick start](https://www.nextflow.io/))
### Not essential:
* Docker installed (see [how to get Docker](https://docs.docker.com/get-docker/))

## How to install (simple way)
***
Installation is just about:
1. Build Docker image to create container where to run the pipeline from Nextflow. Once downloaded this project and inside main directory, just run the following commands:
```
$ docker pull ncbi/sra-tools
$ docker build -t preprocessing .
```
2. Insert in **reference** directory the chosen reference sequence.

3. Overwrite ***SRA_list.txt*** with SRA accesion number of the samples. 

4. Open ***nextflow.config*** file and overwrite this parameters :

    1. *params.fasta* : need to change the name of the reference sequence chosen
    2. *profiles->local->process->withName:Contigs->cpus* : this parameter should make faster (or slower) the execution of contigs computing (need this for SHIVER method) based on the number of core used in this process. 
    3. *profiles->local->process->withName:Make_SNV_list_SHIVER->cpus* : this parameter should make faster (or slower) the execution of SNV list file computing (need this for SHIVER method) based on the number of core used in this process.
    4. make the same as 2. and 3. for profile ***docker***

5. Overwrite :
    1. ***shiver_setting/MyConfig_bowtie2.sh***
    2. ***shiver_setting/MyConfig_bwa.sh***
    3. ***shiver_setting/MyConfig_smalt.sh***

    to do this (adapt the pipeline to the purpose) need to know about SHIVER's method (linked above).

## How to use(simple way)
***
Once created the Docker image, you have to see trough the file ***nextflow.config*** to check you have only to run this commands choosing the right options:
```
$  ./nextflow run preprocess.nf -profile docker --aligner [ bowtie2 || bwa || smalt ] --mode [ shiver || classic ]
```

## How to install (custom way)
***
This mode of use is not recommended and has not been thoroughly tested to be able to consider it correct.
Installation is just about:
1. Using Ubuntu (20.04) execute all the CMD command (better if in roder) in ***Dockerfile***, in particular you have to execute commands regarding the initial SHIVER configuration in the main folder of the pipeline.

2. In the main directory of this pipeline there must be the following folders and files (following the CMD in ***Dockerfile*** this will happen automatically) :
    1. **shiver-1.5.8** (simply the download of SHIVER version 1.5.8)
    2. **shiver_settings/setting_bowtie2**
    3. **shiver_settings/setting_bwa**
    4. **shiver_settings/setting_smalt**
    5. ***shiver_settings/MyConfig_bowtie2.sh***
    6. ***shiver_settings/MyConfig_bwa.sh***
    7. ***shiver_settings/MyConfig_smalt.sh***
3. Insert in **reference** directory the chosen reference sequence.

4. Overwrite ***SRA_list.txt*** with SRA accesion number of the samples. 

5. Open ***nextflow.config*** file and overwrite this parameters :

    1. *params.fasta* : need to change the name of the reference sequence chosen
    2. *profiles->local->process->withName:Contigs->cpus* : this parameter should make faster (or slower) the execution of contigs computing (need this for SHIVER method) based on the number of core used in this process. 
    3. *profiles->local->process->withName:Make_SNV_list_SHIVER->cpus* : this parameter should make faster (or slower) the execution of SNV list file computing (need this for SHIVER method) based on the number of core used in this process.
    4. make the same as 2. and 3. for profile ***docker***

6. Overwrite :
    1. ***shiver_setting/MyConfig_bowtie2.sh***
    2. ***shiver_setting/MyConfig_bwa.sh***
    3. ***shiver_setting/MyConfig_smalt.sh***

    to do this (adapt the pipeline to the purpose) need to know about SHIVER's method (linked above).

## How to use (custom way)
***
Once created the Docker image, you have to see trough the file ***nextflow.config*** to check you have only to run this commands choosing the right options:
```
$  ./nextflow run preprocess.nf -profile local --aligner [ bowtie2 || bwa || smalt ] --mode [ shiver || classic ]
```
## Options discovery
***
* ``` -profile ( docker || local )``` : this option tells about the subsystem will run the pipeline, in case of ``` local ``` be sure to have all the necessary requirements installed ( go to requirements section for clarification ). However, it is advisable to use the option ``` docker ```.

* ``` --aligner ( bowtie2 || bwa || smalt ) ``` : simply choosing the suitable aligner.

* ``` --mode ( shiver || classic ) ``` : this options makes you choosing trough classic manner (aligne against a reference sequence) or SHIVER method (follow the link above in section technologies to discover SHIVER).