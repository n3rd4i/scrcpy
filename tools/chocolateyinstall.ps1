$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$url        = 'https://github.com/Genymobile/scrcpy/releases/download/v1.10/scrcpy-win64-v1.10.zip'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  softwareName  = 'scrcpy*'
  checksum      = '95de34575d873c7e95dfcfb5e74d0f6af4f70b2a5bc6fde0f48d1a05480e3a44'
  checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

$IconUrl = 'https://www.iconfinder.com/icons/3185263/download/ico/512'
$IconPath = "$(Join-Path $toolsDir android.ico)"
Get-ChocolateyWebFile -PackageName 'android.ico' `
  -FileFullPath "$IconPath" `
  -Url "$IconUrl" `
  -Checksum "3DFC23DD4D2124C58CAB83B52C98CE59DF9B62A43A46D99A3C703BA340DCEF3A" `
  -ChecksumType "sha256"

## StartMenu
Install-ChocolateyShortcut -ShortcutFilePath "$startMenuDir\$AppName.lnk" `
  -TargetPath "$installLocation\$BinName" `
  -IconLocation "$IconPath" `
  -WorkingDirectory "$installLocation"

## Desktop
Install-ChocolateyShortcut -ShortcutFilePath "$shortcutPath" `
  -TargetPath "$installLocation\$BinName" `
  -IconLocation "$IconPath" `
  -WorkingDirectory "$installLocation"
