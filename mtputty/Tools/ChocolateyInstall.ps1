$packageParameters = @{
  PackageName = 'mtputty'
  FileFullPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\mtputty.exe"
  Url = 'http://ttyplus.com/download/mtputty.exe'
  Checksum = 'C2A81F5DB114ABB5EC44ECA5F69FA6F93723A272B233F313EB363E411CD52069'
  ChecksumType = 'Sha256'
}

Get-ChocolateyWebFile @packageParameters
