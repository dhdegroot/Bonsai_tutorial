param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$SanityArgs
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
        $IMAGE_NAME | Out-Null

    Write-Host 'Container is running.'
    Write-Host "Mounted: $INPUT_DIR -> /mnt"
    Write-Host 'Starting sanity in the container...'

    $sanityArgString = ($SanityArgs -join ' ')
    docker exec `
        -w /mnt `
        -t $CONTAINER_NAME `
        bash -c "mkdir -p sanity_results && /sanity/bin/Sanity $sanityArgString -e 1 -max_v 1 -d sanity_results"

    Write-Host 'Sanity run finished.'
}
finally {
    Cleanup
}
