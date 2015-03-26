$optionsFile = (Join-Path $PSScriptRoot 'options.xml')

if (!(Test-Path $optionsFile)) {
  throw "Install options file missing. Could not uninstall."
}

$options = Import-CliXml -Path $optionsFile
$catalinaHome = Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])";
Install-ChocolateyEnvironmentVariable 'CATALINA_HOME' "$catalinaHome"

$service = Get-Service | ? Name -eq $options['serviceName']
if ($service -ne null) {
  Stop-Service $service
}

$binPath = Join-Path $catalinaHome 'bin'
if (Test-Path $binPath) {
  Push-Location
  Start-ChocolateyProcessAsAdmin ".\service.bat uninstall $($options['serviceName'])"
  Pop-Location
}

if ((Get-ChildItem $options['unzipLocation'] | Measure-Object).Count -eq 1) { 
  Remove-Item $options['unzipLocation'] -Recurse -Force
}
else {
  Remove-Item (Join-Path $options['unzipLocation'] "apache-tomcat-$($options['version'])") -Recurse -Force
}