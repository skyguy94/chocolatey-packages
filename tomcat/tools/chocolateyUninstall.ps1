$packageName = 'tomcat'

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\Install-Service.ps1"
. "$PSScriptRoot\Uninstall-ZipPackage.ps1"

$optionsFile = (Join-Path $PSScriptRoot "install-options.ps1")
if (Test-Path $optionsFile)
{
  $serviceName = Get-Content $optionsFile
  Uninstall-Service "$global:serviceName"
  Remove-Item $optionsFile
}

Uninstall-ZipPackage "$packageName"
