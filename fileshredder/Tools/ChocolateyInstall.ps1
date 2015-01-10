$packageName = 'fileshredder'
$setupType = 'exe'
$setupArgs = '/SILENT'
$32bitUrl = 'http://www.fileshredder.org/files/file_shredder_setup.exe'
$64bitUrl = ''

Install-ChocolateyPackage $packageName $setupType $setupArgs $32bitUrl $64bitUrl

