# Bonsai tutorial: using docker image

## Install Docker

Please follow instructions from https://docs.docker.com/get-started/get-docker/ and install Docker.Desktop on your computer.

## Get bonsai image for the tutorial

Please got to the "DockerHub" in the Docker.Desktop and search for "pachkov/bonsai", click on the corresponding search result

## Download necessary scripts

Please download it from here:

The repository includes Dockerfile if you would like to build image yourself.

## Running tools

We provide a few scripts to run `bonsai`, `bonsai-scout`, `sanity` and `cellstates`. Please see links below:
* Bonsai: https://github.com/dhdegroot/Bonsai-data-representation
* Sanity: https://github.com/jmbreda/Sanity
* Cellstates: https://github.com/nimwegenLab/cellstates

To run the scripts please make a new directory and move/copy the input data into it. The programs from the docker image will use this directory to read and write data. The utilities from the docker image would not have access to your data outside of this directory. 

From now on for illustrating the tools execution we assume that you created directory `test_run` innside of the `Bonsai_tutorial` which contains this README file and scripts.

#### Running Sanity

Execute the following command to run sanity (OSX, Linux):

```bash
bash ../run_sanity.sh -n4 -e 1 -max_v 1 -f example_data.tsv
```

The shell script is followed by sanity command options (please see Sanity documentation) which are necessary to make input files for Bonsai. Results are always saved in directory `sanity_results`. You can change number of threads used with `-n` option. You can change name of the input file with `-f` option. If you you want to try input data in .MTX format than command looks like that:

```bash
bash ../run_sanity.sh -n4 -e 1 -max_v 1 -f example_data.mtx -mtx_genes example_data_genes.tsv --mtx_cells example_data_cellIDs.tsv
```

**For WIndows users** instead of .sh scripts run .ps1 scripts:
```bash
..\run_sanity.ps1 "-n4 -e 1 -max_v 1 -f example_data.tsv"
```
Perhaps you need to execute `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted` in the PowerShell before running .ps1 scripts.

#### Running Cellstates

Execute the following command to run sanity (OSX, Linux):

```bash
bash ../run_cellstates.sh -t 8 --save-intermediates example_data.tsv
```

The shell script is followed by cellstates command options (please see Cellstates documentation) which are necessary to make input files for Bonsai. Results are always saved in directory `cellstates_results`. You can change number of threads used with `-t` option. You can change name of the input file, which id at the very end of the command line. If you you want to try input data in .MTX format than command looks like that:

```bash
bash ../run_cellstates.sh -t 8 --save-intermediates -g example_data_genes.tsv -c example_data_cellIDs.tsv example_data.mtx"
```

**For WIndows users** instead of .sh scripts run .ps1 scripts:
```bash
..\run_cellstates.ps1 "-t 8 --save-intermediates example_data.tsv"
```

#### Running Bonsai

Execute the following command to run bonsai (OSX, Linux):

```bash
bash ../run_bonsai.sh -n 8
```

Here user can only change number of threads for the bonsai execution. The input data for the bonsai is taken from directory `sanity_resuls` and `cellstates_results` (optional). Results of the bonsai run are saved in directory `bonsai_results`.


**For WIndows users** instead of .sh scripts run .ps1 scripts:
```bash
..\run_bonsai.ps1 "-n8"
```

#### Running Bonsai-scout

Execute the following command to run bonsai (OSX, Linux):

```bash
bash ../run_bonsai_scout.sh
```

That starts the bonsai-scout app and you can access it with your browser by url http://localhost:8000
When you finish your work with app please press CTRL-C in the terminal to stop the application. The bonsai-scout app use data from directory `bonsai_results`.


**For WIndows users** instead of .sh scripts run .ps1 scripts:
```bash
..\run_bonsai_scout.ps1 "-n8"
```