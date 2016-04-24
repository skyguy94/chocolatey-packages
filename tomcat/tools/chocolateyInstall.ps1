$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" };

$options = @{
    version = '8.0.33';
    unzipLocation = (Join-Path $PFFolder "Apache Software Foundation\tomcat");
    serviceName = 'Tomcat8';
}

$unzipParameters = @{
    packageName = 'tomcat';
    url = "https://archive.apache.org/dist/tomcat/tomcat-8/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x86.zip";
    url64bit = "https://archive.apache.org/dist/tomcat/tomcat-8/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x64.zip";
    checksum = '99469b119c3265a9e4149e0f771deea9';
    checksumType = 'md5';
    checksum64 = '7f1c6a4d666b9c76ef3b72038c5a891e';
    checksumType64 = 'md5';
}

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
Install-ChocolateyZipPackage @unzipParameters -UnzipLocation $options['unzipLocation']

$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"
$binPath = Join-Path $catalinaHome 'bin'

Push-Location $binPath
Start-ChocolateyProcessAsAdmin ".\service.bat install $($options['serviceName'])"
Pop-Location

Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options

Get-Service |? Name -eq $options['serviceName'] | Start-Service
