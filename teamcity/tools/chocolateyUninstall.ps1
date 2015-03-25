$optionsFile = (Join-Path $PSScriptRoot 'options.xml')

if (!(Test-Path $optionsFile))
{
  throw "Install options file missing. Could not uninstall."
}

$options = Import-CliXml -Path $optionsFile

Push-Location (Join-Path $options['unzipLocation'] 'TeamCity\bin')
$process = Start-Process -FilePath 'teamcity-server.bat' -ArgumentList 'service', 'delete' -Wait -WindowStyle Hidden -PassThru
Pop-Location
if ($process.ExitCode -ne 0) {
  throw "Uninstalling the TeamCity service failed: $LastExitCode"
}

Remove-Item (Join-Path $options['unzipLocation'] 'TeamCity') -Recurse -Force