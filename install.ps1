$ErrorActionPreference = 'Stop'

$private:dir = Split-Path -Parent $PSCommandPath

$dependencies = Import-PowerShellDataFile (Join-Path $dir 'Dependencies.psd1')
$repositories = $dependencies.Repositories
$resources = $dependencies.Resources

Register-PSResourceRepository -Repository $repositories -Force

$resources = Invoke-Command -ScriptBlock {
    $valid = (Get-Command Install-PSResource).Parameters.Keys
    $in = $resources
    $out = @{}

    foreach ($name in $resources.Keys) {
        $out[$name] = @{}
        foreach ($param in $in[$name].Keys) {
            if (!$valid.Contains($param)) {
                continue
            }
            $out[$name][$param] = $in[$name][$param]
        }
    }

    return $out
}
Install-PSResource -RequiredResource $resources -Reinstall -TrustRepository
