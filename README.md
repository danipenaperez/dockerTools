# dockerTools
Simple Unix script with utilities to manage local Docker installation

## Getting Started

Not needed compilation, only shell script execution. Please ensure you have installed Docker and is available on $PATH.


## dockerRemoveImageAndContainers.sh

This script remove images based on Repository or repository:version , and all related containers and volumes (running or not)

### Usage example

> ./dockerRemoveImageAndContainers.sh company/myservicename 0.1.2

## Authors

* **Daniel Peña Perez** - *Initial work* - [Profile](https://github.com/danipenaperez)

See also the list of [contributors](github.com/danipenaperez/dockerTools/contributors) who participated in this project.