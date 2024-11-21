$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$url = 'https://github.com/Genymobile/scrcpy/releases/download/v2.6/scrcpy-win64-v2.6.zip'
$folderName = $(Split-Path $url -leaf).replace('.zip', '')

# 1. Download bundle
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = "$(Join-Path $ENV:TEMP 'scrcpy.zip')"
  url           = $url
  checksum      = '3D490A72997AF950AEC0540E28627ADA35C8226BC9774500014C9697D9B53194'
  checksumType  = 'sha256'
}
$archivePath = Get-ChocolateyWebFile @packageArgs

# 2. Extract bundle in $ENV:TEMP
$packageArgs = @{
  packageName     = $env:ChocolateyPackageName
  unzipLocation   = $ENV:TEMP
  fileFullPath    = $archivePath
}
$extractedFolder = Get-ChocolateyUnzip @packageArgs
Remove-Item -Path $archivePath

$sourceFolder = Join-Path -Path $extractedFolder -ChildPath $folderName
if (Test-Path -Path $installLocation) {
    Copy-Item -Path "$sourceFolder\*" -Destination $installLocation -Recurse -Force
    Remove-Item -Path $sourceFolder -Recurse -Force
}

$pp = Get-PackageParameters
if ($pp['ExcludeADB'] -eq 'true') {
Remove-Item -Path "$(Join-Path $toolsDir adb.exe)"
Remove-Item -Path "$(Join-Path $toolsDir AdbWinApi.dll)"
Remove-Item -Path "$(Join-Path $toolsDir AdbWinUsbApi.dll)"
}

if ($pp['DontShimADB'] -eq 'true') {
New-Item "$(Join-Path $toolsDir adb.exe.ignore)" -type file -force | Out-Null
}

$iconPath = "$(Join-Path $toolsDir 'icon.ico')"

## StartMenu
Install-ChocolateyShortcut -ShortcutFilePath "$startMenuDir\$AppName.lnk" `
  -TargetPath "$installLocation\$BinName" `
  -IconLocation "$iconPath" `
  -WorkingDirectory "$installLocation"

## Desktop
Install-ChocolateyShortcut -ShortcutFilePath "$shortcutPath" `
  -TargetPath "$installLocation\$BinName" `
  -IconLocation "$iconPath" `
  -WorkingDirectory "$installLocation"
