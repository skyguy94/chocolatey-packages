$packageParameters = @{
  PackageName = 'mtputty'
  FileFullPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\mtputty.exe"
  Url = 'http://ttyplus.com/download/mtputty.exe'
  Checksum = 'B2C2FD593BDEA890202BC55C398812878D8E185C6AF45980D9DDBDCE5B4946F6'
  ChecksumType = 'Sha256'
}

Get-ChocolateyWebFile @packageParameters
