$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$url        = 'https://github.com/Genymobile/scrcpy/releases/download/v1.13/scrcpy-win64-v1.13.zip'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = '806AAFC00D4DB01513193ADDAA24F47858893BA5EFE75770BFEF6AE1EA987D27'
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
