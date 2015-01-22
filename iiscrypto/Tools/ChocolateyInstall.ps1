$packageName = 'iiscrypto-commandline'
$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$localFile = Join-Path $toolsPath "iiscrypto.exe"
$localFile40 = Join-Path $toolsPath "iiscrypto40.exe"

Get-ChocolateyWebFile $packageName $localFile 'https://www.nartac.com/Products/IISCrypto/IISCrypto.exe'
Get-ChocolateyWebFile $packageName $localFile40 'https://www.nartac.com/Products/IISCrypto/IISCrypto40.exe'

