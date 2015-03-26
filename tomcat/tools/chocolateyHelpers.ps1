function Set-ChocolateyPackageOptions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=1)]
        [hashtable] $options
    )
    $packageParameters = $env:chocolateyPackageParameters;

    if ($packageParameters) {
        $parameters = ConvertFrom-StringData -StringData $env:chocolateyPackageParameters.Replace(" ", "`n")
        $parameters.GetEnumerator() | % {
           $options[($_.Key)] = ($_.Value)
        }
    }
}