using System;

public record struct Release(Version Version, Uri Uri, string Checksum);
