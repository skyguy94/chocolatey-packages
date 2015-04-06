$packageName = 'mtputty'
$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$localFile = Join-Path $toolsPath "mtputty.exe"
$url = 'http://ttyplus.com/download/mtputty.exe'

Get-ChocolateyWebFile $packageName $localFile $url
