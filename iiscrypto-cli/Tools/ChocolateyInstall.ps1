$packageName = 'iiscrypto-commandline'
$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$localFile = Join-Path $toolsPath "iiscryptocli.exe"
$localFile40 = Join-Path $toolsPath "iiscryptocli40.exe"

Get-ChocolateyWebFile $packageName $localFile 'https://www.nartac.com/Downloads/IISCrypto/IISCryptoCli.exe'
Get-ChocolateyWebFile $packageName $localFile40 'https://www.nartac.com/Products/IISCrypto/IISCryptoCli40.exe'

