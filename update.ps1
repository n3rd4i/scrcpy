import-module au

$domain   = 'https://github.com'
$releases = "$domain/Genymobile/scrcpy/releases"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"   	= "`$1'$($Latest.Checksum32)'"
    }
  }
}

# 'https://github.com/Genymobile/scrcpy/releases/download/v1.14/scrcpy-win64-v1.14.zip'
function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing #1
  $regex   = 'scrcpy-win64-v\d+.\d+(.\d+)?.zip$'
  $sublink     = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
  $url = ($domain, $sublink) -join ''
  $token = $url -split 'scrcpy-win64-v' | select -First 1 -Skip 1 #3
  $version = $token -split '.zip' | select -Last 1 -Skip 1 #3
  return @{ Version = $version; URL32 = $url }
}

update -ChecksumFor 32
