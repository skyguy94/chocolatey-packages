if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\ChocolateyHelpers.ps1"

$version = '14.0.23107.156'

$options = @{
    productKey = ''
    adminFile = (Join-Path $PSScriptRoot 'AdminFile.xml')
    extraFeatures = 'VS_SDK_GROUPV3'
}

$packageParameters = @{
  packageName = 'visualstudio2015-professional';
  url = 'http://download.microsoft.com/download/5/8/9/589A8843-BA4D-4E63-BCB2-B2380E5556FD/vs_professional.exe';
  silentArgs = '/Passive /NoRestart'
  installerType = 'exe'
}

Set-ChocolateyPackageOptions $options

if ($options['extraFeatures']) {
  [xml]$xml = Get-Content $adminFile
  foreach ($feature in $options['extraFeatures'].Split(',')) {
      $node = $xml.DocumentElement.SelectableItemCustomizations.ChildNodes | Where-Object { $_.Id -eq $feature }
      if ($node) {
          $node.Selected = 'yes'
      }
  }

  $xml.DocumentElement.SelectableItemCustomizations.ChildNodes |
    Sort-Object Selected -Descending |
    ForEach-Object {
      $xml.DocumentElement.SelectableItemCustomizations.AppendChild($_) | Out-Null
    }
  $xml.Save($adminFile)
}

$packageParameters['silentArgs'] += " /Log $Env:Temp\$packageName.log /AdminFile $adminFile" 
if ($options['ProductKey']) {
    $packageParameters['silentArgs'] += (" /ProductKey" + $options['ProductKey'])
}

Install-ChocolateyPackage @packageParameters -ValidExitCodes @(0, 3010, 2147781575, -2147185721, -2147205120, -2147172352)