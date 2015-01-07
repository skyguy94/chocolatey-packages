$packageName = 'SSCERuntime-ENU'
$fileType = 'exe'
$tempDir = (Join-Path (Join-Path $env:TEMP "chocolatey") "$packageName")

if (Test-Path $tempDir) {
  Remove-Item -Recurse -Force $tempDir
}
if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }

$file = Join-Path $tempDir "$($packageName)Install.$fileType"
Get-ChocolateyWebFile 'SSCERuntime-ENU' $file 'http://download.microsoft.com/download/E/C/1/EC1B2340-67A0-4B87-85F0-74D987A27160/SSCERuntime-ENU.exe'

Invoke-Expression "$file /T:$tempDir /q"
Install-ChocolateyPackage 'mssqlserver-compact3.5-x32' 'msi' '/quiet /passive' (Join-Path $tempDir 'SSCERuntime_x86-ENU.msi') '' @(0,1603)
if (Get-ProcessorBits -eq 64) {
    Install-ChocolateyPackage 'mssqlserver-compact3.5-x64' 'msi' '/quiet /passive' '' (Join-Path $tempDir 'SSCERuntime_x64-ENU.msi') @(0,1603)
}