$packageParameters = @{
    packageName = 'teamcity-server';
    url = 'http://download.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz';
    url64bit = '';
    checksum = '';
    checksumType = '';
    checksum64 = '';
    checksumType64 = '';
}

$options = @{
    unzipLocation = 'C:\';
    runAsSystem = $true;
    userName = '';
    domain = '';
    password = '';
}

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
if ($options['userName'] -ne '' -and $options['password'] -ne '')
{
  $options['runAsSystem'] = $false;
}

$binPath = Join-Path $options['unzipLocation'] 'TeamCity\bin'
if (Test-Path $binPath)
{
  Push-Location $binPath
  Start-Process -FilePath 'teamcity-server.bat' -ArgumentList 'service', 'delete' -Wait -WindowStyle Hidden -PassThru
  Pop-Location
}

$tempFolder = Get-ChocolateyPackageTempFolder
Get-ChocolateyWebFile @packageParameters -FileFullPath $tempFolder
Get-ChocolateyUnzip -FileFullPath $tempFolder -Destination $tempFolder -PackageName $packageParameters['packageName']
Get-ChocolateyUnzip -FileFullPath (Join-Path $tempFolder "TeamCity-9.0.3.tar") -Destination $options['unzipLocation'] -PackageName $packageParameters['packageName']

Push-Location $binPath
$args = @('service', 'install')
if ($options['runAsSystem'])
{
  $args.Add('/runAsSystem')
}
else
{
  $args.Add("/user=`"($options['userName'])`"")
  $args.Add("/password=`"($options['password'])`"")
  if ($options['domain'] -ne '')
  {
  $args.Add("/password=`"($options['domain'])`"")
  }
}
$process = Start-Process -FilePath 'teamcity-server.bat' -ArgumentList $args -Wait -WindowStyle Hidden -PassThru
Pop-Location

if ($process.ExitCode -ne 0) {
  throw "Installing the TeamCity service failed: $LastExitCode"
}

$options['password'] = '';
Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options