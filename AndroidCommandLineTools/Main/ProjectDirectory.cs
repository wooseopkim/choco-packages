using System.IO.Abstractions;
using System.Reflection;

namespace AndroidCommandLineTools.Main;

abstract internal class ProjectDirectory(IFileSystem fs, params string[] paths)
{

    protected readonly IFile File = fs.File;
    protected readonly IDirectoryInfoFactory DirectoryInfo = fs.DirectoryInfo;
    private readonly string BasePath = Path.Join(paths);

    private static readonly string RootPath = new Func<string>(() =>
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
            Path.Join(projectNameSegments)
        );
    })();

    public IDirectoryInfo NewDirectoryInfo(params string[] paths)
    {
        return DirectoryInfo.New(ResolvePath(paths));
    }

    protected string ResolvePath(params string[] paths)
    {
        return Path.Combine(RootPath, BasePath, Path.Join(paths));
    }
}
