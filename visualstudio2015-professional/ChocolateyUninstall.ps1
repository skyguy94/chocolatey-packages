$applicationName = 'Microsoft Visual Studio Professional 2015'
$uninstallerName = 'vs_professional.exe'

$packageParameters = @{
  packageName = 'VisualStudio2015Professional'
  installerType = 'exe'
  silentArgs = '/Uninstall /force /Passive /NoRestart'
  file = ''
}

$product = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "$applicationName*"} | Sort-Object { $_.Name } | Select-Object -First 1
$uninstaller = Get-ChildItem "$Env:ProgramData\Package Cache\" -Recurse -Filter $uninstallerName | Where-Object { $_.VersionInfo.ProductVersion.StartsWith($product.Version) }
if ($product -and $uninstaller) {
  $packageParameters['File'] = $uninstaller.FullName
  Uninstall-ChocolateyPackage @packageParameters
}