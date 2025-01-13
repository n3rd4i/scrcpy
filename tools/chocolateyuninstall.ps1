$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -force
}
if (Test-Path "$startMenuDir") {
    Remove-Item "$startMenuDir" -recurse -force
}
Remove-Item $installLocation -recurse -force
