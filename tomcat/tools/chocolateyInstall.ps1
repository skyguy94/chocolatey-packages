$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" };

$options = @{
    version = '7.0.69';
    unzipLocation = (Join-Path $PFFolder "Apache Software Foundation\tomcat");
    serviceName = 'Tomcat7';
}

$unzipParameters = @{
    packageName = 'tomcat';
    url = "https://archive.apache.org/dist/tomcat/tomcat-7/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x86.zip";
    url64bit = "https://archive.apache.org/dist/tomcat/tomcat-7/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x64.zip";
    checksum = 'ce764b8bd89e4c142c460ad8e6ff8b08';
    checksumType = 'md5';
    checksum64 = '1cafbe7fe52f7da6882d1aa8e1febd4a';
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
