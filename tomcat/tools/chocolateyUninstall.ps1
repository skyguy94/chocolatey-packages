$packageName = 'tomcat'

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\Install-Service.ps1"
. "$PSScriptRoot\Uninstall-ZipPackage.ps1"

Uninstall-Service "$packageName"

Uninstall-ZipPackage "$packageName"