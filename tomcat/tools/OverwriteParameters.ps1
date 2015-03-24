function OverwriteParameters {
	$arguments = @{};
	$packageParameters = $env:chocolateyPackageParameters;

	if($packageParameters) {
		$MATCH_PATTERN = "/([a-zA-Z]+)=(.*)(`")"
		$PARAMETER_NAME_INDEX = 1
		$VALUE_INDEX = 2
		
		if($packageParameters -match $MATCH_PATTERN) {
			$results = $packageParameters | Select-String $MATCH_PATTERN -AllMatches 
			
			$results.matches | %{ 
			$arguments.Add(
				$_.Groups[$PARAMETER_NAME_INDEX].Value.Trim(),
				$_.Groups[$VALUE_INDEX].Value.Trim()) 
			}
		}     
		
		if($arguments.ContainsKey("InstallLocation")) {
			$global:installLocation = $arguments["InstallLocation"];
			
			Write-Host "Value variable installLocation changed to $global:installLocation"
		}

		if($arguments.ContainsKey("availablePort")) {
			$global:availablePort = $arguments["availablePort"];
			
			Write-Host "Value variable availablePort changed to $global:availablePort"
		}
  }	
}