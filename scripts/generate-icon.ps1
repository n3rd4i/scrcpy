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

Assert-ProgramExist -ProgramName 'magick' -Reason 'to convert png to ico'

magick convert $ICON_PNG -filter point -define icon:auto-resize=16,32,48,64,128,256 -compress jpeg $ICON_ICO
Remove-Item $ICON_PNG
