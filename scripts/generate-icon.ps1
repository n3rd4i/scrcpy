$iconSource = "https://raw.githubusercontent.com/Genymobile/scrcpy/v1.18/app/src/icon.xpm"

$projectDir = "$((get-item $MyInvocation.MyCommand.Definition).Directory.parent)"
$toolsDir   = "$(Join-Path $projectDir tools)"

# icons paths
$ICON_XPM = "$(Join-Path $ENV:TEMP icon.xpm)"
$ICON_PNG = "$(Join-Path $ENV:TEMP icon.png)"
$ICON_ICO = "$(Join-Path $toolsDir icon.ico)"

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($iconSource, $ICON_XPM)

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

magick convert $ICON_XPM -filter point -resize 128x $ICON_PNG
Remove-Item $ICON_XPM

Assert-ProgramExist -ProgramName 'png2ico' -Reason 'to convert png to ico'
png2ico $ICON_ICO $ICON_PNG
Remove-Item $ICON_PNG
