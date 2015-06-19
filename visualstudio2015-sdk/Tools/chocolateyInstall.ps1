try {
	$packageName = 'visualstudio2015-sdk'
	$downloadUrl = 'http://download.microsoft.com/download/1/9/4/194D9E3A-3E78-421A-8A28-30A3D9A52A46/vssdk_full.exe'

	$logFilePath = Join-Path $env:TEMP 'vssdk_full.log'
	$installArgs = '/Passive /NoRestart /Log ' + $logFilePath
	Install-ChocolateyPackage $packageName 'exe' $installArgs $downloadUrl -validExitCodes @(0,3010)
} catch {
  throw $_.Exception
}
