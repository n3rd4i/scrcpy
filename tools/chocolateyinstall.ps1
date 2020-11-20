$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = 'https://github.com/Genymobile/scrcpy/releases/download/v1.16/scrcpy-win64-v1.16.zip'
  checksum      = '3f30dc5db1a2f95c2b40a0f5de91ec1642d9f53799250a8c529bc882bc0918f0'
  checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

$pp = Get-PackageParameters
if ($pp['ExcludeADB'] -eq 'true') {
Remove-Item -Path "$(Join-Path $toolsDir adb.exe)"
Remove-Item -Path "$(Join-Path $toolsDir AdbWinApi.dll)"
Remove-Item -Path "$(Join-Path $toolsDir AdbWinUsbApi.dll)"
}

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
