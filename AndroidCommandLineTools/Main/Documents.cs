using AngleSharp.Dom;

namespace AndroidCommandLineTools.Main;

internal static class Documents
{

    public static Release ParseRelease(IDocument document)
    {
        var cells = document.QuerySelectorAll("table.download tr:not(:has(th))")
          .Where(x => Strings.IndicatesCommandLineTools(x.TextContent))
          .SelectMany(x => x.QuerySelectorAll("td"))
          .Select(x => x.TextContent.Trim())
          .AsEnumerable();
        var fileName = cells.First(Strings.IsFileName);
        var checksum = cells.First(Strings.IsChecksum);

        var version = Strings.ParseVersion(fileName);
        var url = $"https://dl.google.com/android/repository/{fileName}";

        return new Release(
            Checksum: new Checksum(checksum),
            Version: new Version(version),
            Uri: new Uri(url)
        );
    }
}
