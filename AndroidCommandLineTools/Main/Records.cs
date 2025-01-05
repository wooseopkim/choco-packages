namespace AndroidCommandLineTools.Main;



internal record struct Checksum(string Value);

internal record struct Version(string Value);

internal record struct Release(Checksum Checksum, Version Version, Uri Uri);
