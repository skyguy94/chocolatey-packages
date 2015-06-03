$options = @{
  version = '{version}';
}

$packageParameters = @{
  packageName = 'CEDevEnvironment';
  url = "https://download.careevolution.com/CEDevEnvironment/CEDevEnvironment-$($options['version']).zip";
  unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  url64bit = '';
  checksum = '';
  checksumType = '';
  checksum64 = '';
  checksumType64 = '';
}

$downloadFile = Join-Path $Env:Temp ($packageParameters['packageName'] + ".zip")

$retries = 2;
while ($retries -ne 0)
{
    Try
    {
        if (!$credential)
        {
            if (![Environment]::UserInteractive)
            {
                Write-Host "Script is in NonInteractive mode and credentials were not specified. Aborting..."
                return 1;
            }
            
            $cache = (New-Object Net.CredentialCache)
            $credential = (New-Object Net.CredentialCache).GetCredential("download.careevolution.com", "Basic")
            if ($storedCredential -eq $null)
            {
              $credential = Get-Credential -Message "Enter the user name and password for downloading the ISO"
            }
        }

        $client = (New-Object Net.WebClient)
        $client.Credentials = $credential
        if ($client.DownloadString("https://download.careevolution.com")) { break }
    }
    Catch
    {
        Write-Host "Could not authenticate $($credential.UserName)."
        $retries--
        $credential = $null
    }

    if ($retries -eq 0)
    {
        Write-Host "Download failed. Please check your credentials and try again."
        return 1;
    }
}

$client = (New-Object Net.WebClient)
$client.Credentials = $credential
$client.DownloadFile($packageParameters['url'], $downloadFile)
Get-ChocolateyUnzip $downloadFile $packageParameters['unzipLocation']
