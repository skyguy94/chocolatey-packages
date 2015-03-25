$packageName = 'tomcat'
$32BitUrl = 'https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59-windows-x86.zip'
$64BitUrl = 'https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59-windows-x64.zip'
$global:installLocation = if (Get-ProcessorBits) { "$Env:ProgramFiles" } else { "$Env:ProgramFiles(x86)" }
$checksum = '84fe2d5237c8569ef748700d1ac1dfba'
$checksumType = 'md5'
$checksum64 = 'a4121b78c8eb12c7af0b7fad6fec39d6'
$checksumType64 = 'md5'
$global:availablePort = '8080'
$serviceName = 'Tomcat7'

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\OverwriteParameters.ps1"
. "$PSScriptRoot\Install-Service.ps1"

OverwriteParameters
Set-Content -Path (Join-Path $PSScriptRoot "install-options.ps1") -Value "$serviceName"

Install-ChocolateyZipPackage "$packageName" "$32BitUrl" "$global:installLocation" "$64BitUrl" -checksum "$checksum" -checksumType "$checksumType" -checksum64 "$checksum64" -checksumType64 "$checksumType64"

$catalinaHome = "$global:installLocation\apache-tomcat-7.0.59"
$createServiceCommand = "${catalinaHome}\bin\service.bat install $serviceName"

Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"

Install-Service $packageName $serviceName $createServiceCommand $global:availablePort