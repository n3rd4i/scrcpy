$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = 'https://github.com/Genymobile/scrcpy/releases/download/v1.18/scrcpy-win64-v1.18.zip'
  checksum      = '37212f5087fe6f3e258f1d44fa5c02207496b30e1d7ec442cbcf8358910a5c63'
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
$iconPath = "$(Join-Path $toolsDir $iconSrc'.ico')"
Get-ChocolateyWebFile -PackageName $iconPath `
  -FileFullPath $iconPath `
  -Url 'https://raw.githubusercontent.com/n3rd4i/scrcpy/8827f45f5d631c46545e935442f567a417d17998/assets/icon.ico' `
  -Checksum '269B7310504B534A22FA7568CCBC203FDEFA9F335911F93456D8A8E9E193D897' `
  -ChecksumType 'sha256'

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
