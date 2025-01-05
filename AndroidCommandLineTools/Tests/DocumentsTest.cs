using AngleSharp;

namespace AndroidCommandLineTools.Tests;

public class DocumentsTest
{


    [Fact]
    public async Task TestParseRelease()
    {
        var config = Configuration.Default.WithDefaultLoader();
        var context = BrowsingContext.New(config);
        var document = await context.OpenAsync((req) => req.Content(TestData.ReadAllText("studio.html")));

        var release = Documents.ParseRelease(document);

        Assert.Equal(actual: release.Checksum.Value, expected: "4d6931209eebb1bfb7c7e8b240a6a3cb3ab24479ea294f3539429574b1eec862");
        Assert.Equal(actual: release.Version.Value, expected: "11076708");
        Assert.Equal(actual: release.Uri.AbsoluteUri, expected: "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip");
    }
}
