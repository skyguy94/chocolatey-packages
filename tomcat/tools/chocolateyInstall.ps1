$unzipParameters = @{
    PackageName = 'tomcat';
    Url = 'https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59-windows-x86.zip';
    Url64bit = 'https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59-windows-x64.zip';
    Checksum = '84fe2d5237c8569ef748700d1ac1dfba';
    ChecksumType = 'md5';
    Checksum64 = 'a4121b78c8eb12c7af0b7fad6fec39d6';
    ChecksumType64 = 'md5';
}

$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" };
$unzipLocation = Join-Path $PFFolder "Apache Software Foundation\tomcat";
$options = @{
    unzipLocation = $unzipLocation;
    serviceName = 'Tomcat7';
}

Get-Service |? Name -eq $options['serviceName'] | Stop-Service

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
Install-ChocolateyZipPackage @unzipParameters -UnzipLocation $options['unzipLocation']

$catalinaHome = Join-Path $options['unzipLocation'] 'apache-tomcat-7.0.59\bin';
$process = Start-Process -FilePath (Join-Path $catalinaHome 'service.bat') -ArgumentList 'install', ($options['ServiceName']) -Wait -WindowStyle Hidden -PassThru
if ($process.ExitCode -ne 0) {
  throw "Installing `"$options['serviceName']`" service failed: $LastExitCode"
}

Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options
