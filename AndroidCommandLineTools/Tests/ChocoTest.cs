using System.IO.Abstractions;
using System.IO.Abstractions.TestingHelpers;
using System.Xml.Linq;
using Version = AndroidCommandLineTools.Main.Version;

namespace AndroidCommandLineTools.Tests;

public class ChocoTest
{

    [Fact]
    public async Task TestGeneratePackage()
    {
        var release = new Release(
            new Checksum("checksum"),
            new Version("version"),
            new Uri("https://example.com/v1/download")
        );
        var fs = new MockFileSystem();
        var File = fs.File;
        var input = new ReadOnlyProjectDirectory(new FileSystem(), "Assets");
        var output = new WriteOnlyProjectDirectory(fs, "Output");

        await Choco.GeneratePackage(
            input: input,
            output: output,
            release: release
        );

        var dir = output.NewDirectoryInfo();
        var installScript = await File.ReadAllTextAsync(Path.Combine(dir.FullName, "tools", "chocolateyInstall.ps1"));
        Assert.Contains(
            expectedSubstring: "helpers.ps1",
            actualString: installScript,
            StringComparison.InvariantCulture
        );
        Assert.Contains(
            expectedSubstring: $"Url = 'https://example.com/v1/download'",
            actualString: installScript,
            StringComparison.InvariantCulture
        );
        Assert.Contains(
            expectedSubstring: "Checksum = 'checksum'",
            actualString: installScript,
            StringComparison.InvariantCulture
        );
        Assert.Contains(
            expectedSubstring: "Path = \"$toolsPath\"",
            actualString: installScript,
            StringComparison.InvariantCulture
        );
        var nuspec = await File.ReadAllTextAsync(Path.Combine(dir.FullName, "android-commandlinetools.nuspec"));
        var versionElement = XDocument.Parse(nuspec)
            .Descendants()
            .Where(x => x.Name.LocalName == "version")
            .First();
        Assert.Equal(expected: release.Version.Value, actual: versionElement.Value);
    }
}
