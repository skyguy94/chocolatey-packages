$packageParameters = @{
  PackageName = 'fileshredder'
  SetupType = 'exe'
  SilentArgs = '/SILENT'
  Url = 'http://www.fileshredder.org/files/file_shredder_setup.exe'
  Checksum = '72714927DE74B97C524C5FA8BC1A0DEC83F038DBBED80B93B5E6280CA1317F41'
  ChecksumType = 'Sha256'
}

Install-ChocolateyPackage @packageParameters

