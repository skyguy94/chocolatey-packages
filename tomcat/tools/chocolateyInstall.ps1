$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" };

$options = @{
    version = '8.0.39';
    unzipLocation = (Join-Path $PFFolder "Apache Software Foundation\tomcat");
    serviceName = 'Tomcat8';
}

$unzipParameters = @{
    packageName = 'tomcat';
    url = "http://archive.apache.org/dist/tomcat/tomcat-8/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x86.zip";
    url64bit = "http://archive.apache.org/dist/tomcat/tomcat-8/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x64.zip";
    checksum = '3686E28BFEC3D5F335427B955C69045C2BC4C4A2652D8CB0385CE71612326A32';
    checksumType = 'sha256';
    checksum64 = '0DDCB0DA168C0B999C2F924FBECA344AAF12E3F067DC0EA1CE1EF304FF6EDDE7';
    checksumType64 = 'sha256';
}

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
Install-ChocolateyZipPackage @unzipParameters -UnzipLocation $options['unzipLocation']

$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"

Push-Location (Join-Path $catalinaHome 'bin')
Start-ChocolateyProcessAsAdmin ".\service.bat install $($options['serviceName'])"
Pop-Location

Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options

Get-Service |? Name -eq $options['serviceName'] | Start-Service
