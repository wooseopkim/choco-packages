# For some reason, the proprety `Stream IResponse.Content` takes precedence to `VirtualResponse.Content(string)`.
# Until I find a better way, I'm using reflection API to invoke the `Content` method.
# https://github.com/AngleSharp/AngleSharp/blob/c089bfc8c1d1d648dff05d814b865e9a61164ca3/src/AngleSharp/Io/VirtualResponse.cs#L57
$virtualResponseContentMethod = [AngleSharp.IO.VirtualResponse].GetDeclaredMethods('Content') | ForEach-Object {
    $params = $_.GetParameters()
    if ($params.Count -Ne 1) {
        return
    }
    if ($params.ParameterType -Ne [System.String]) {
        return
    }
    return $_
}

function Get-Document {
    [OutputType([AngleSharp.Dom.Document])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Uri
    )

    $html = (Invoke-WebRequest -Uri $Uri).Content
    $context = [AngleSharp.BrowsingContext]::New([AngleSharp.Configuration]::Default)
    # https://anglesharp.github.io/docs/core/03-Examples#parsing-a-well-defined-document
    $request = [Action[AngleSharp.Io.VirtualResponse]] {
        param($req)
        $virtualResponseContentMethod.Invoke($req, $html)
    }
    $task = [AngleSharp.BrowsingContextExtensions]::OpenAsync($context, $request)
    return $task.GetAwaiter().GetResult()
}
