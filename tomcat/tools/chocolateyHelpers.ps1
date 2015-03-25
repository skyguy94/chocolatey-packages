function Set-ChocolateyPackageOptions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=1)]
        [hashtable] $options
    )
    $packageParameters = $env:chocolateyPackageParameters;

    if ($packageParameters) {
        $match = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
        if (!($packageParameters -match $match )) {
            Throw "Package options were found but were invalid (REGEX Failure)."
        }

        $results = $packageParameters | Select-String $match -AllMatches
        $results.Matches | % {
           $options[$_.Groups['option'].Value.Trim()] = ($_.Groups['value'].Value.Trim())
        }
    }
}