$packageName = 'sql2005-xmo'
$setupType = 'msi'
$setupArgs = '/quiet'
$32bitUrl = 'http://download.microsoft.com/download/3/1/6/316FADB2-E703-4351-8E9C-E0B36D9D697E/SQLServer2005_XMO.msi'
$64bitUrl = 'http://download.microsoft.com/download/3/1/6/316FADB2-E703-4351-8E9C-E0B36D9D697E/SQLServer2005_XMO_x64.msi'

Install-ChocolateyPackage $packageName $setupType $setupArgs $32bitUrl $64bitUrl
