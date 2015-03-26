$optionsFile = (Join-Path $PSScriptRoot 'options.xml')

if (!(Test-Path $optionsFile))
{
  throw "Install options file missing. Could not uninstall."
}

$options = Import-CliXml -Path $optionsFile

Push-Location (Join-Path $options['unzipLocation'] 'TeamCity\bin')
Start-ChocolateyProcessAsAdmin '.\teamcity-server.bat service delete'
Pop-Location

Remove-Item (Join-Path $options['unzipLocation'] 'TeamCity') -Recurse -Force