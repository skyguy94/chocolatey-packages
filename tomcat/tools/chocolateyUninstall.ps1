$optionsFile = (Join-Path $PSScriptRoot 'options.xml')

if (!(Test-Path $optionsFile))
{
  throw "Install options file missing. Could not uninstall."
}

$options = Import-CliXml -Path $optionsFile

Get-Service |? Name -eq $options['serviceName'] | Stop-Service

$catalinaHome = Join-Path $options['unzipLocation'] 'apache-tomcat-7.0.59';
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"

$process = Start-Process -FilePath (Join-Path $catalinaHome 'bin\service.bat') -ArgumentList 'uninstall', 'Tomcat7' -Wait -WindowStyle Hidden -PassThru
if ($process.ExitCode -ne 0) {
  throw "Uninstalling `"$options['serviceName']`" service failed: $LastExitCode"
}

Remove-Item (Join-Path $options['unzipLocation'] 'apache-tomcat-7.0.59') -Recurse -Force