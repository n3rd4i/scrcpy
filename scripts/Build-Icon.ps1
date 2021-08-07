$param1=$args[0]

$iconSourceTag = $param1

$projectDir = "$((get-item $MyInvocation.MyCommand.Definition).Directory.parent)"
$assetsDir   = "$(Join-Path $projectDir assets)"

# Submodule assets
$submoduleDir = "$(Join-Path $projectDir modules\github.com\Genymobile\scrcpy)"
$iconSourcePath = "app/src/icon.xpm"
$iconSource = "$(Join-Path $submoduleDir $iconSourcePath)"

git -C $submoduleDir fetch
git -C $submoduleDir checkout $iconSourceTag

# icons paths
$assetIco = "$(Join-Path $assetsDir icon.ico)"

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

Assert-ProgramExist -ProgramName 'magick' -Reason 'to convert xpm to ico'

magick convert $iconSource -filter point -resize 128x $assetIco

(Get-FileHash assets\icon.ico -Algorithm SHA256).Hash > "$assetIco.sha256"

@"
``$(Resolve-Path -Relative $assetIco)`` is generated using
``$(Resolve-Path -Relative $iconSource)`` obtained
from https://github.com/Genymobile/scrcpy/blob/$iconSourceTag/$iconSourcePath,
licensed under https://github.com/Genymobile/scrcpy/blob/$iconSourceTag/LICENSE.
"@ > "$assetIco.NOTICE.md"
