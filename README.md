# Bonsai tutorial: using docker image

## Install Docker

Please follow the instructions from https://docs.docker.com/get-started/get-docker/ and install "Docker Desktop" on your computer.

## Clone this "Bonsai_tutorial"-repository 

Go to https://github.com/ismara-unibas/Bonsai_tutorial and use the green "Code"-button to either download the code as a Zip-folder, or clone the repository using Git-commands. 

## Get bonsai image for the tutorial

Go to the "DockerHub" in the "Docker Desktop"-app and search for "pachkov/bonsai"; click on the corresponding search result. In that folder, click Pull. After DockerHub is done downloading, one should be able to find an entry "pachkov/bonsai" under Images. 
Alternatively, the "Bonsai_tutorial"-repository also includes a Dockerfile so that one can re-build the Docker image, rather than downloading it from DockerHub. We here do not provide detailed instructions for that.

## Running tools

In the Bonsai_tutorial-reposiotry, and the Docker-image, we provide all you need to run `bonsai`, `bonsai-scout`, `sanity` and `cellstates`. Please see the links below for more information on these individual steps:
* Bonsai: https://github.com/dhdegroot/Bonsai-data-representation
* Sanity: https://github.com/jmbreda/Sanity
* Cellstates: https://github.com/nimwegenLab/cellstates

To run the scripts on a dataset, please create a dedicated directory for that dataset. Move the input-matrix (containing the scRNA-seq counts) into this directory. The programs from the Docker image will use this directory to read and write data. The utilities from the Docker image will not have access to your data outside of this directory. 

To illustrate the execution of the scripts, we already created a directory called "test_run" within the "Bonsai_tutorial"-repository. In this ReadMe, we will assume that we run all methods on this example dataset, so that one should change the commands accordingly for another dataset.

#### Running Sanity

Open a terminal (PowerShell on Windows), navigate to the "Bonsai_tutorial/test_run"-direcotry, and execute the following command to run sanity (OSX, Linux):

```bash
bash ../run_sanity.sh -n 4 -e 1 -max_v 1 -f example_data.tsv
```

The shell script is followed by sanity command options (please see Sanity documentation) which are necessary to get the correct input files for Bonsai. Results are always saved in a newly-created sub-directory `sanity_results`. You can change the number of threads used with `-n` option. You can change the name of the input file with the `-f` option. Note that, the above command assumes that the count table is a .tsv-file with as its first row the cell-IDs, and its first column the gene-IDs. Alternatively, one can run _Sanity_ on data in the sparse .mtx-format. In that case, the user has to supply .tsv-files containing the gene- and cell-IDs. For example:

```bash
bash ../run_sanity.sh -n 4 -e 1 -max_v 1 -f example_data.mtx -mtx_genes example_data_genes.tsv --mtx_cells example_data_cellIDs.tsv
```

**For WIndows users:** instead of .sh scripts run .ps1 scripts:
```bash
..\run_sanity.ps1 "-n 4 -e 1 -max_v 1 -f example_data.tsv"
```
Perhaps you need to execute `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted` in the PowerShell before running .ps1 scripts.

#### Running Cellstates

**Note:** Running Cellstates is not strictly necessary for reconstructing a Bonsai-tree, but the Cellstates-results can be used to create an initial tree for _Bonsai_'s reconstruction algorithm. It usually takes some time, however, so it is possible to skip this step. The script `run_bonsai.sh` will automatically detect whether a Cellstates-run was finished, and then determine to use these results or not.

Execute the following command to run Cellstates (OSX, Linux):

```bash
bash ../run_cellstates.sh -t 8 --save-intermediates example_data.tsv
```

The shell script is followed by cellstates command options (please see Cellstates documentation) which are necessary to make input files for Bonsai. Results are always saved in the sub-directory `cellstates_results`. You can change the number of threads used with the `-t` option. You can change the input file that is used by changing the path at the end of the command, i.e., by replacing "example_data.tsv" by a path to your input file. If you you want to try input data in .MTX format then the command should look like:

```bash
bash ../run_cellstates.sh -t 8 --save-intermediates -g example_data_genes.tsv -c example_data_cellIDs.tsv example_data.mtx"
```

**For WIndows users** instead of .sh scripts run .ps1 scripts:
```bash
..\run_cellstates.ps1 "-t 8 --save-intermediates example_data.tsv"
```
Perhaps you need to execute `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted` in the PowerShell before running .ps1 scripts.

#### Running Bonsai

Once Sanity (and optionally Cellstates) are finished, you can execute the following command to run bonsai (OSX, Linux):

```bash
bash ../run_bonsai.sh -n 8
```

Here user can only change number of threads for the bonsai execution. The input data for the bonsai is taken from directory `sanity_resuls` and `cellstates_results` (optional). Results of the bonsai run are saved in directory `bonsai_results`.


**For WIndows users** instead of .sh scripts run .ps1 scripts:
```bash
..\run_bonsai.ps1 "-n8"
```
Perhaps you need to execute `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted` in the PowerShell before running .ps1 scripts.

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
Perhaps you need to execute `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted` in the PowerShell before running .ps1 scripts.
