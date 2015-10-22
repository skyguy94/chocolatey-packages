$packageName = 'visualstudio2015-sdk'
$downloadUrl = 'http://download.microsoft.com/download/9/1/0/910EE61D-A231-4DAB-BD56-DCE7092687D5/vssdk_full.exe'

$logFilePath = Join-Path $env:TEMP 'vssdk_full.log'
$installArgs = '/Passive /NoRestart /Log ' + $logFilePath
Install-ChocolateyPackage $packageName 'exe' $installArgs $downloadUrl -validExitCodes @(0,3010)