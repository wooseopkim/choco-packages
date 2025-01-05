using AndroidCommandLineTools.Main;

namespace AndroidCommandLineTools.Tests;

public class StringsTest
{

    [Theory]
    [InlineData(["commandlinetools-win-11076708_latest.zip", true])]
    [InlineData(["command-line-tools_windows", true])]
    [InlineData(["CommandLineTools.Win", true])]
    [InlineData(["commandxlinextools-win", false])]
    public void TestIndicatesCommandLineTools(string value, bool ok)
    {
        var result = Strings.IndicatesCommandLineTools(value);

        Assert.Equal(expected: ok, actual: result);
    }

    [Theory]
    [InlineData(["commandlinetools-win-11076708_latest.zip", true])]
    [InlineData(["foo.jpeg", true])]
    [InlineData(["MyAwesomeScript.ps1.crdownload", true])]
    [InlineData(["This is a file too.av1", true])]
    [InlineData(["but/this/is/not.txt", false])]
    [InlineData(["not a file", false])]
    public void TestIsFileName(string value, bool ok)
    {
        var result = Strings.IsFileName(value);

        Assert.Equal(expected: ok, actual: result);
    }

    [Theory]
    [InlineData(["4d6931209eebb1bfb7c7e8b240a6a3cb3ab24479ea294f3539429574b1eec862", true])]
    [InlineData(["checksumanyways1", true])]
    [InlineData(["Not0A0Checksum", false])]
    [InlineData(["NotAChecksumToo", false])]
    [InlineData(["01234", true])]
    [InlineData(["1.2.3", false])]
    public void TestIsChecksum(string value, bool ok)
    {
        var result = Strings.IsChecksum(value);

        Assert.Equal(expected: ok, actual: result);
    }

    [Theory]
    [InlineData(["commandlinetools-win-11076708_latest.zip", "11076708"])]
    [InlineData(["commandlinetools-win-11076708.zip", "11076708"])]
    [InlineData(["android-studio-2024.2.1.12-linux.tar.gz", "2024.2.1.12"])]
    [InlineData(["I think the version should be 1.2.3 here", "1.2.3"])]
    public void TestParseVersion(string s, string version)
    {
        var result = Strings.ParseVersion(s);

        Assert.Equal(expected: version, actual: result);
    }
}
