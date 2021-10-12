# Preprocessing for Mutational signatures (via Docker)
Re-styling preprocessing for [VirMutSig](https://github.com/BIMIB-DISCo/VirMutSig) using Docker.


## Technologies
***
* [Nextflow](https://www.nextflow.io/)
* [Docker](https://www.docker.com/)

## Prerequisites
***
* Docker installed (see [how to get Docker](https://docs.docker.com/get-docker/))
* Nextflow prerequisites (see [quick start](https://www.nextflow.io/))

## How to install
***
Installation is just about build 2 Docker images to create container where to run the pipelines from Nextflow. Once downloaded this project and inside main directory, just run the following command:
```
$ docker build -t preprocessing .
$ docker build -t preprocessing_index -f Dockerfile.index .
```
At the end of the execution the image will have been created starting from Dockerfile. The image has been tagged with preprocessing.

## How to use
***
Once created the Docker image you have only to run this command:
* for preprocessing index
```
$ ./nextflow run pre-processing_index.nf -with-docker preprocessing_index -c nextflow_dsl2.config
```
* for preprocessing
```
$ ./nextflow run pre-processing.nf -with-docker preprocessing -c nextflow_dsl2.config
```