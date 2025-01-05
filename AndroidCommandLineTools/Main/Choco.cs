using System.Globalization;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Linq;

namespace AndroidCommandLineTools.Main;

internal class Choco
{

    private const string ToolsDirectory = "tools";

    private const string InstallScriptName = "chocolateyInstall.ps1";

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
                uri: release.Uri,
                version: release.Version
            ),
            instance.GenerateTools(
                uri: release.Uri,
                checksum: release.Checksum
            )
        );
    }

    private async Task GenerateNuspec(Uri uri, Version version)
    {
        var xml = await Input.ReadAllTextAsync("template.nuspec");
        var root = XDocument.Parse(xml).Root
            ?? throw new XmlException("document root is null");
        var metadata = root.Element(root.GetDefaultNamespace() + "metadata")
            ?? throw new XmlException("metadata is null");

        var packageName = Regex.Replace(Project.Name, @"\.Main$", "");
        var map = new Dictionary<string, string>()
        {
            ["id"] = packageName.ToLower(CultureInfo.CurrentCulture),
            ["version"] = version.Value,
            ["packageSourceUrl"] = "https://github.com/wooseopkim/choco-packages",
            ["owners"] = "wooseopkim",
            ["title"] = packageName,
            ["projectUrl"] = "https://cs.android.com/android-studio/platform/tools/base",
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
        var nuspecContent = root.ToString();
        await Output.WriteAllTextAsync(paths: nuspecPath, contents: nuspecContent);
    }

    private async Task GenerateTools(Uri uri, Checksum checksum)
    {
        var src = Input.NewDirectoryInfo(ToolsDirectory);
        var dest = Output.NewDirectoryInfo(ToolsDirectory);
        src.CopyInto(dest);

        var installScriptPath = Path.Join(ToolsDirectory, InstallScriptName);
        var installScriptContent = $@".\install.ps1 -Url '{uri.AbsoluteUri}' -Checksum '{checksum.Value}'";
        await Output.WriteAllTextAsync(paths: installScriptPath, contents: installScriptContent);
    }
}
