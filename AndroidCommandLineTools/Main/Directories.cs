using System.IO.Abstractions;

namespace AndroidCommandLineTools.Main;

internal static class Directories
{

    /// <summary>
    ///   See <a
    ///     href="https://github.com/dotnet/docs/blob/a66f296e0044f607bcfd1e57b2a7f5b5b09ed581/docs/standard/io/snippets/how-to-copy-directories/csharp/Program.cs"
    ///   >this</a> taken from <a
    ///     href="https://github.com/dotnet/docs/blob/a66f296e0044f607bcfd1e57b2a7f5b5b09ed581/docs/standard/io/how-to-copy-directories.md"
    ///   >here</a>.
    /// </summary>
    public static void CopyInto(this IDirectoryInfo src, IDirectoryInfo dest)
    {
        var DirectoryInfo = dest.FileSystem.DirectoryInfo;
        var FileInfo = dest.FileSystem.FileInfo;

        if (!src.Exists)
        {
            throw new DirectoryNotFoundException($"Source directory not found: {src.FullName}");
        }

        dest.Create();
        foreach (var file in src.GetFiles())
        {
            var target = Path.Combine(dest.FullName, file.Name);
            file.CopyInto(FileInfo.New(target));
        }

        var subDirs = src.GetDirectories();
        foreach (var subDir in subDirs)
        {
            var target = Path.Combine(dest.FullName, subDir.Name);
            subDir.CopyInto(DirectoryInfo.New(target));
        }
    }

    private static void CopyInto(this IFileInfo src, IFileInfo dest)
    {
        using var reader = new StreamReader(src.OpenRead());
        using var writer = new StreamWriter(dest.OpenWrite());
        writer.Write(reader.ReadToEnd());
    }
}
