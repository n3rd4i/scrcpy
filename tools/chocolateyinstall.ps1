$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = 'https://github.com/Genymobile/scrcpy/releases/download/v1.17/scrcpy-win64-v1.17.zip'
  checksum      = '8b9e57993c707367ed10ebfe0e1ef563c7a29d9af4a355cd8b6a52a317c73eea'
  checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

$pp = Get-PackageParameters
if ($pp['ExcludeADB'] -eq 'true') {
Remove-Item -Path "$(Join-Path $toolsDir adb.exe)"
Remove-Item -Path "$(Join-Path $toolsDir AdbWinApi.dll)"
Remove-Item -Path "$(Join-Path $toolsDir AdbWinUsbApi.dll)"
}

if ($pp['DontShimADB'] -eq 'true') {
New-Item "$(Join-Path $toolsDir adb.exe.ignore)" -type file -force | Out-Null
}

## Download & Convert game shortcuts icon
$iconSrc = 'android'
$iconSrcPath = "$(Join-Path $ENV:TEMP $iconSrc'.png')"
$iconPath = "$(Join-Path $toolsDir $iconSrc'.ico')"
Get-ChocolateyWebFile -PackageName $iconSrc `
  -FileFullPath $iconSrcPath `
  -Url 'https://www.iconfinder.com/icons/317758/download/png/128' `
  -Checksum 'B2FE913ED202C908D10ACD1D602CCDB24E2E79F3009570E2CADAF22694FFA4DA' `
  -ChecksumType 'sha256'
& png2ico.exe $iconPath $iconSrcPath

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
