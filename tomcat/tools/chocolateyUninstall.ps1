$optionsFile = (Join-Path $PSScriptRoot 'options.xml')

if (!(Test-Path $optionsFile))
{
  throw "Install options file missing. Could not uninstall."
}

$options = Import-CliXml -Path $optionsFile


Get-Service |? Name -eq $options['serviceName'] | Stop-Service

$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"

Push-Location Join-Path $catalinaHome 'bin'
Start-ChocolateyProcessAsAdmin ".\service.bat uninstall $($options['serviceName'])"
Pop-Location

Remove-Item (Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])") -Recurse -Force