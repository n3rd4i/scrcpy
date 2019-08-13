$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$AppName = 'ScrCpy'
$BinName = "$($AppName.ToLower()).exe"
$installLocation = "$toolsDir"
$startMenuDir = [IO.Path]::Combine($ENV:AppData, 'Microsoft\Windows\Start Menu\Programs', "$AppName")
$shortcutPath = [IO.Path]::Combine($ENV:UserProfile, 'Desktop', "$AppName.lnk")
