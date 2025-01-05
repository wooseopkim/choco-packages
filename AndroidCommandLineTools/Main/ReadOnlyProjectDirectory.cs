using System.IO.Abstractions;

namespace AndroidCommandLineTools.Main;

internal class ReadOnlyProjectDirectory(IFileSystem fs, params string[] paths) : ProjectDirectory(fs, paths)
{

    public Task<string> ReadAllTextAsync(params string[] paths)
    {
        return File.ReadAllTextAsync(ResolvePath(paths));
    }
}
