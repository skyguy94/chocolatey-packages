$optionsFile = (Join-Path $PSScriptRoot 'options.xml')

if (!(Test-Path $optionsFile))
{
  throw "Install options file missing. Could not uninstall."
}

$options = Import-CliXml -Path $optionsFile

Get-Service |? Name -eq $options['serviceName'] | Stop-Service

$catalinaHome = Join-Path $options['unzipLocation'] 'apache-tomcat-7.0.59\bin';
$process = Start-Process -FilePath (Join-Path $catalinaHome 'service.bat') -ArgumentList 'uninstall', $options['ServiceName'] -Wait -WindowStyle Hidden -PassThru
if ($process.ExitCode -ne 0) {
  throw "Uninstalling `"$options['serviceName']`" service failed: $LastExitCode"
}

Remove-Item (Join-Path $options['unzipLocation'] 'apache-tomcat-7.0.59') -Recurse -Force