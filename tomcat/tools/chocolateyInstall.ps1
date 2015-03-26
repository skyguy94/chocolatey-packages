$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" };

$options = @{
    version = '7.0.59';
    unzipLocation = (Join-Path $PFFolder "Apache Software Foundation\tomcat");
    serviceName = 'Tomcat7';
}

$unzipParameters = @{
    PackageName = 'tomcat';
    Url = "https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-$($options['version'])-windows-x86.zip";
    Url64bit = "https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-$($options['version'])-windows-x64.zip";
    Checksum = '84fe2d5237c8569ef748700d1ac1dfba';
    ChecksumType = 'md5';
    Checksum64 = 'a4121b78c8eb12c7af0b7fad6fec39d6';
    ChecksumType64 = 'md5';
}

Get-Service |? Name -eq $options['serviceName'] | Stop-Service

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
Install-ChocolateyZipPackage @unzipParameters -UnzipLocation $options['unzipLocation']

$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"
 
Push-Location (Join-Path $catalinaHome 'bin')
Start-ChocolateyProcessAsAdmin ".\service.bat install ($options['serviceName'])"
Pop-Location

Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options

Get-Service |? Name -eq $options['serviceName'] | Start-Service
