$packageName = 'iiscrypto-commandline'
$toolsPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$localFile = Join-Path $toolsPath "iiscrypto.exe"

Get-ChocolateyWebFile $packageName $localFile 'https://www.nartac.com/Downloads/IISCrypto/IISCrypto.exe'

