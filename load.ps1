$ErrorActionPreference = 'Stop'

$private:dir = Split-Path -Parent $PSCommandPath

$deps = Import-PowerShellDataFile (Join-Path $dir 'Dependencies.psd1')

foreach ($resource in Get-InstalledPSResource) {
    $name = $resource.Name
    $library = $deps.Resources[$name].Library
    if (-Not $library) {
        continue
    }
    $location = Join-Path $resource.InstalledLocation $name
    $path = (Get-ChildItem -Filter '*.dll' -File -Recurse $location).FullName | ForEach-Object {
        $segments = $_ -Split ([System.IO.Path]::DirectorySeparatorChar), 0, 'SimpleMatch'
        if (-Not ($segments -Match $library)) {
            return
        }
        return $_
    }
    if (-Not $path) {
        continue
    }
    Add-Type -Path $path -ErrorAction SilentlyContinue
}

Get-ChildItem -Path (Join-Path $dir 'main' '*.cs') | ForEach-Object {
    $name = $_.BaseName
    $path = $_.FullName
    if ([System.Management.Automation.PSTypeName]::new($name).Type) {
        return
    }
    Add-Type -Path $path
}
