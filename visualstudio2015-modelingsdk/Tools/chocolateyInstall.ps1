$packageName = 'visualstudio2015-modelingsdk'
$downloadUrl = 'http://download.microsoft.com/download/A/6/5/A6527B55-2836-42F3-B22E-49A4C96E01B0/vs_vmsdk.exe'

$logFilePath = Join-Path $env:TEMP 'vs_vmsdk.log'
$installArgs = '/Passive /NoRestart /Log ' + $logFilePath
Install-ChocolateyPackage $packageName 'exe' $installArgs $downloadUrl -validExitCodes @(0,3010)