$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/Genymobile/scrcpy/releases/download/v1.9/scrcpy-win64-v1.9.zip'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  softwareName  = 'scrcpy*'
  checksum      = '0088eca1811ea7c7ac350d636c8465b266e6c830bb268770ff88fddbb493077e'
  checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs
