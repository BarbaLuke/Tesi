# Preprocessing for Mutational signatures (via Docker)
Re-styling preprocessing for [VirMutSig](https://github.com/BIMIB-DISCo/VirMutSig) using Docker.


## Technologies
***
* [Nextflow](https://www.nextflow.io/)
* [Docker](https://www.docker.com/)
* [Shiver](https://github.com/ChrisHIV/shiver)

## Prerequisites
***
* Docker installed (see [how to get Docker](https://docs.docker.com/get-docker/))
* Nextflow prerequisites (see [quick start](https://www.nextflow.io/))

## How to install
***
Installation is just about build Docker image to create container where to run the pipeline from Nextflow and download Shiver. Once downloaded this project and inside main directory, just run the following commands:
```
$ mkdir setting 
$ shiver-1.5.8/shiver_init.sh setting MyConfig.sh reference/HIV_1.fasta reference/MyAdapters.fasta reference/MyPrimers.fasta
$ docker build -t preprocessing_shiver -f Dockerfile.index .
```
(!IMPORTANT follow the exact commands order)
At the end of the execution the image will have been created starting from Dockerfile. The image has been tagged with preprocessing_shiver. Shiver has been initialized and the settings are stored in /setting directory

## How to use
***
Once created the Docker image and settings for Shiver you have only to run this command:
* now can run the pipeline 
```
$ ./nextflow run preprocessing_shiver.nf -with-docker preprocessing_shiver -c nextflow_dsl2.config
```