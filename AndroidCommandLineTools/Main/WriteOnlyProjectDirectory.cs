using System.IO.Abstractions;

namespace AndroidCommandLineTools.Main;

internal class WriteOnlyProjectDirectory(IFileSystem fs, params string[] paths) : ProjectDirectory(fs, paths)
{

    public Task WriteAllTextAsync(string contents, params string[] paths)
    {
        return File.WriteAllTextAsync(path: ResolvePath(paths), contents: contents);
    }
}
