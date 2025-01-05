using System.Reflection;

namespace AndroidCommandLineTools.Tests;

internal static class TestData
{

    private const string TestDataDirectory = "TestData";
    private static readonly string BasePath = new Func<string>(() =>
    {
        var projectNameSegments = Assembly.GetExecutingAssembly()
            .GetName()
            .Name
            !.Split('.');
        var repositoryRoot = AppDomain.CurrentDomain
            .BaseDirectory
            .Split(Path.DirectorySeparatorChar)
            .TakeWhile(x => x != projectNameSegments.First())
            .Aggregate(Directory.GetDirectoryRoot(Directory.GetCurrentDirectory()), Path.Combine);
        return Path.Join(
            repositoryRoot,
            Path.Join(projectNameSegments),
            TestDataDirectory
        );
    })();

    public static string ReadAllText(string path)
    {
        return File.ReadAllText(Path.Combine(BasePath, path));
    }
}
