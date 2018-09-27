$PFFolder = if (Get-ProcessorBits -eq 64) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" }

$options = @{
    version = '9.0.12'
    unzipLocation = (Join-Path $PFFolder "Apache Software Foundation\tomcat")
    serviceName = 'Tomcat8'
}

$unzipParameters = @{
    packageName = 'tomcat'
    url = "https://archive.apache.org/dist/tomcat/tomcat-9/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x86.zip"
    url64bit = "https://archive.apache.org/dist/tomcat/tomcat-9/v$($options['version'])/bin/apache-tomcat-$($options['version'])-windows-x64.zip"
    checksum = '1cd84d46a879ffe2c442f849530c86e291a03c80'
    checksumType = 'sha1'
    checksum64 = '1733a3ea0af0fc96b201bc0496424db3c472725e'
    checksumType64 = 'sha1'
}

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

Set-ChocolateyPackageOptions $options
Install-ChocolateyZipPackage @unzipParameters -UnzipLocation $options['unzipLocation']

$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"

$binPath =  Join-Path $catalinaHome 'bin'
Push-Location $binPath
Start-ChocolateyProcessAsAdmin ".\service.bat install $($options['serviceName'])"
Pop-Location

Export-CliXml -Path (Join-Path $PSScriptRoot 'options.xml') -InputObject $options

Get-Service | Where-Object Name -eq $options['serviceName'] | Start-Service
