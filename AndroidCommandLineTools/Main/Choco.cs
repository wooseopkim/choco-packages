using System.Data;
using System.Xml;
using System.Xml.Linq;

namespace AndroidCommandLineTools.Main;

internal class Choco
{

    private const string ToolsDirectory = "tools";

    private readonly ReadOnlyProjectDirectory Input;
    private readonly WriteOnlyProjectDirectory Output;

    private Choco(ReadOnlyProjectDirectory input, WriteOnlyProjectDirectory output)
    {
        Input = input;
        Output = output;
    }

    public static async Task GeneratePackage(ReadOnlyProjectDirectory input, WriteOnlyProjectDirectory output, Release release)
    {
        var instance = new Choco(input: input, output: output);
        await Task.WhenAll(
            instance.GenerateNuspec(
                version: release.Version
            ),
            instance.GenerateTools(
                uri: release.Uri,
                checksum: release.Checksum
            )
        );
    }

    private async Task GenerateNuspec(Version version)
    {
        var xml = await Input.ReadAllTextAsync("template.nuspec");
        var doc = XDocument.Parse(xml);
        var root = doc.Root
            ?? throw new XmlException("document root is null");
        var metadata = root.Element(root.GetDefaultNamespace() + "metadata")
            ?? throw new XmlException("metadata is null");

        var packageName = "android-commandlinetools";
        var map = new Dictionary<string, string>()
        {
            ["id"] = packageName,
            ["version"] = version.Value,
            ["packageSourceUrl"] = "https://github.com/wooseopkim/choco-packages",
            ["owners"] = "wooseopkim",
            ["title"] = "Android Command-Line Tools",
            ["projectUrl"] = "https://developer.android.com/studio#command-line-tools-only",
            ["docsUrl"] = "https://developer.android.com/tools",
            ["projectSourceUrl"] = "https://cs.android.com/android-studio/platform/tools/base",
            ["authors"] = "Google",
            ["description"] = "Android SDK Command-Line Tools",
            ["iconUrl"] = "https://developer.android.com/static/images/brand/android-head_flat.png",
        };
        foreach (var (k, v) in map)
        {
            metadata.UpsertChild(key: k, value: v);
        }

        Output.NewDirectoryInfo().Create();
        var nuspecPath = $"{packageName}.nuspec";
        var nuspecContent = doc.ToString();
        await Output.WriteAllTextAsync(paths: nuspecPath, contents: nuspecContent);
    }

    private async Task GenerateTools(Uri uri, Checksum checksum)
    {
        var src = Input.NewDirectoryInfo(ToolsDirectory);
        var dest = Output.NewDirectoryInfo(ToolsDirectory);
        src.CopyInto(dest);

        await Task.WhenAll(
            GenerateInstallScript(uri: uri, checksum: checksum),
            GenerateUninstallScript()
        );
    }

    private async Task GenerateInstallScript(Uri uri, Checksum checksum)
    {
        var command = "Install-AndroidCommandLineTools";
        var arguments = new Dictionary<string, string>()
        {
            ["Url"] = $"'{uri.AbsoluteUri}'",
            ["Checksum"] = $"'{checksum.Value}'",
            ["Path"] = "\"$toolsPath\"",
        };
        await GenerateWrapperScript(
            paths: "chocolateyInstall.ps1",
            command: command,
            arguments: arguments
        );
    }

    private async Task GenerateUninstallScript()
    {
        var command = "Uninstall-AndroidCommandLineTools";
        var arguments = new Dictionary<string, string>()
        {
            ["Path"] = "\"$toolsPath\"",
        };
        await GenerateWrapperScript(
            paths: "chocolateyUninstall.ps1",
            command: command,
            arguments: arguments
        );
    }

    private async Task GenerateWrapperScript(string command, Dictionary<string, string> arguments, params string[] paths)
    {
        var header = """
        $toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
        . (Join-Path $toolsPath 'helpers.ps1')
        """;

        var body = $$"""
        $arguments = @{
        {{arguments.Select(x => $"  {x.Key} = {x.Value}").Aggregate((acc, x) => $"{acc}\n{x}")}}
        }
        {{command}} @arguments
        """;

        var script = $"""
        {header}

        {body}

        """;

        await Output.WriteAllTextAsync(
            paths: [ToolsDirectory, .. paths],
            contents: script
        );
    }
}
