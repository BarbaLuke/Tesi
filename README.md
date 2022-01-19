# Preprocessing for Mutational signatures (via Docker)
Re-styling preprocessing for [VirMutSig](https://github.com/BIMIB-DISCo/VirMutSig) using Docker for HIV.

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
Installation is just about build Docker image to create container where to run the pipeline from Nextflow. Once downloaded this project and inside main directory, just run the following commands:
```
$ docker pull ncbi/sra-tools
$ docker image ncbi/sra-tools:latest sra_downloads:latest
$ docker build -t preprocessing .
```
At the end of the execution the image will have been created starting from Dockerfile. The image has been tagged with preprocessing. Any shiver update should be done before creating the docker images and the folder settings for each aligner must also be updated.

## How to use
***
Once created the Docker image you have only to run this command:
* now can run the pipeline (an example)
```
$  ./nextflow run preprocess.nf -profile docker --aligner ( bowtie2 || bwa || smalt ) --mode shiver
```