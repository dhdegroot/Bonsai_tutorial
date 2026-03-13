param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$CellstatesArgs
)

$ErrorActionPreference = 'Stop'

$CONTAINER_NAME = 'bonsai'
$IMAGE_NAME = 'pachkov/bonsai'
$INPUT_DIR = (Get-Location).Path

function Cleanup {
    Write-Host ''
    Write-Host "Stopping and removing container '$CONTAINER_NAME'..."
    docker rm -f $CONTAINER_NAME *> $null
}

try {
    $runningContainers = docker ps --format '{{.Names}}'
    if ($runningContainers -contains $CONTAINER_NAME) {
        Write-Host "Container '$CONTAINER_NAME' is already running. Restarting it..."
        docker rm -f $CONTAINER_NAME | Out-Null
    }
    else {
        $allContainers = docker ps -a --format '{{.Names}}'
        if ($allContainers -contains $CONTAINER_NAME) {
            Write-Host "Container '$CONTAINER_NAME' exists but is not running. Removing it..."
            docker rm $CONTAINER_NAME | Out-Null
        }
    }

    Write-Host "Starting container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."
    docker run -d `
        --name $CONTAINER_NAME `
        -v "${INPUT_DIR}:/mnt" `
        $IMAGE_NAME

    Write-Host 'Container is running.'
    Write-Host "Mounted: $INPUT_DIR -> /mnt"
    Write-Host 'Starting cellstates in the container...'

    $cellstatesArgString = ($CellstatesArgs -join ' ')
    docker exec `
        -w /mnt `
        -t $CONTAINER_NAME `
        bash -c "source /cellstates/cellstates_venv/bin/activate && mkdir -p cellstates_results && python /cellstates/scripts/run_cellstates.py $cellstatesArgString -o cellstates_results"

    Write-Host 'Cellstates run finished.'
}
finally {
    Cleanup
}
