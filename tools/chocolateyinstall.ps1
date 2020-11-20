$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$(Join-Path $toolsDir commonEnv.ps1)"

$url        = 'https://github.com/Genymobile/scrcpy/releases/download/v1.12.1/scrcpy-win64-v1.12.1.zip'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = '57D34B6D16CFD9FE169BC37C4DF58EBD256D05C1EA3FEBC63D9CB0A027AB47C9'
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
