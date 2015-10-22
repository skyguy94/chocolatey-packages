$packageName = 'visualstudio2015-modelingsdk'
$downloadUrl = 'https://download.microsoft.com/download/0/B/0/0B05CE52-5C57-46E9-8C27-C5C4DF10C8C0/vs_vmsdk.exe'
                
$logFilePath = Join-Path $env:TEMP 'vs_vmsdk.log'
$installArgs = '/Passive /NoRestart /Log ' + $logFilePath
Install-ChocolateyPackage $packageName 'exe' $installArgs $downloadUrl -validExitCodes @(0,3010)