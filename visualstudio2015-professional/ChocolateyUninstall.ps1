$installerType = 'exe'
$silentArgs = '/Uninstall /force /Passive /NoRestart'

$key = Get-Item 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{19ddbf98-aca3-4fef-9d77-7095b105dd73}'
if ($key)
{
  $values = $key.GetValue('QuietUninstallString') -split '"'
  Uninstall-ChocolateyPackage 'visualstudio2015-professional' 'exe' $values[2] $values[1]
}