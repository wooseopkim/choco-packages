using System.Text.RegularExpressions;

namespace AndroidCommandLineTools.Main;

internal static partial class Strings
{

    [GeneratedRegex("command[^a-z]*line[^a-z]*tools[^a-z]*win", RegexOptions.IgnoreCase)]
    private static partial Regex CommandLineToolsRegex { get; }

    [GeneratedRegex(@"^[^/]+\.[^.]+$", RegexOptions.IgnoreCase)]
    private static partial Regex FileNameRegex { get; }

    [GeneratedRegex(@"^[a-z\d]*\d+[a-z\d]*$")]
    private static partial Regex ChecksumRegex { get; }

    [GeneratedRegex(@"[\d]+([a-z\d.]+)?(?=(\.[a-z\d]+|[^a-z\d.]))", RegexOptions.IgnoreCase)]
    private static partial Regex VersionRegex { get; }

    public static bool IndicatesCommandLineTools(string s)
    {
        return CommandLineToolsRegex.IsMatch(s);
    }

    public static bool IsFileName(string s)
    {
        return FileNameRegex.IsMatch(s);
    }

    public static bool IsChecksum(string s)
    {
        return ChecksumRegex.IsMatch(s);
    }

    public static string ParseVersion(string s)
    {
        return VersionRegex.Match(s).Value;
    }
}
