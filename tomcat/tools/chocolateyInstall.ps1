$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" };

$options = @{
    version = '8.0.32';
    unzipLocation = (Join-Path $PFFolder "Apache Software Foundation\tomcat");
    serviceName = 'Tomcat8';
}

$unzipParameters = @{
    packageName = 'tomcat';
    url = "https://archive.apache.org/dist/tomcat/tomcat-8/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x86.zip";
    url64bit = "https://archive.apache.org/dist/tomcat/tomcat-8/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x64.zip";
    checksum = '1393f5cd080f14963fbd5dcf9741b7bf';
    checksumType = 'md5';
    checksum64 = '148d9deab641de732769f1ed6db4dff1';
    checksumType64 = 'md5';
}

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
Install-ChocolateyZipPackage @unzipParameters -UnzipLocation $options['unzipLocation']

$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
$binPath = Join-Path $catalinaHome 'bin'

Push-Location $binPath
Start-ChocolateyProcessAsAdmin ".\service.bat install $($options['serviceName'])"
Pop-Location

Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options

Get-Service |? Name -eq $options['serviceName'] | Start-Service
