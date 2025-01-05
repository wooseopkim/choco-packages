using System.IO.Abstractions.TestingHelpers;

namespace AndroidCommandLineTools.Tests;

public class DirectoriesTest
{
    [Fact]
    public void TestCopyInto()
    {
        var fs = new MockFileSystem(new Dictionary<string, MockFileData>
        {
            [Path.Combine("foo", "bar")] = new MockDirectoryData(),
            [Path.Combine("foo", "bar", "one")] = new MockFileData("1"),
            [Path.Combine("foo", "bar", "two")] = new MockFileData("2"),
            [Path.Combine("foo", "bar", "a", "b", "c", "d", "e", "f", "g")] = new MockFileData("Hello, world!"),
            [Path.Combine("foo", "bar", "empty")] = new MockDirectoryData(),
            [Path.Combine("foo", "something")] = new MockFileData("don't copy this"),
            [Path.Combine("baz")] = new MockDirectoryData(),
        });
        var DirectoryInfo = fs.DirectoryInfo;
        var File = fs.File;
        var src = DirectoryInfo.New(Path.Combine("foo", "bar"));
        var dest = DirectoryInfo.New(Path.Combine("baz", "qux"));

        src.CopyInto(dest);

        Assert.Equal(
            expected: "1",
            actual: File.ReadAllText(Path.Combine("baz", "qux", "one"))
        );
        Assert.Equal(
            expected: "2",
            actual: File.ReadAllText(Path.Combine("baz", "qux", "two"))
        );
        Assert.Equal(
            expected: "Hello, world!",
            actual: File.ReadAllText(Path.Combine("baz", "qux", "a", "b", "c", "d", "e", "f", "g"))
        );
        Assert.True(DirectoryInfo.New(Path.Combine("baz", "qux", "empty")).Exists);
        Assert.False(File.Exists(Path.Combine("baz", "something")));
    }
}
