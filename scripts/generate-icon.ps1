$iconSource = "https://github.com/Genymobile/scrcpy/raw/master/data/icon.png"

$projectDir = "$((get-item $MyInvocation.MyCommand.Definition).Directory.parent)"
$toolsDir   = "$(Join-Path $projectDir tools)"

# icons paths
$ICON_PNG = "$(Join-Path $ENV:TEMP icon.png)"
$ICON_ICO = "$(Join-Path $toolsDir icon.ico)"

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($iconSource, $ICON_PNG)

function Assert-ProgramExist {
    param (
        $ProgramName,
        $Reason
    )

    if (!(Get-Command -Name $ProgramName -ErrorAction SilentlyContinue))
    {
        $ErrorMessage = "$ProgramName is required $Reason"
        throw $ErrorMessage
    }
}

Assert-ProgramExist -ProgramName 'magick' -Reason 'to convert xpm to png'

magick convert $ICON_PNG -filter point $ICON_ICO
Remove-Item $ICON_PNG
