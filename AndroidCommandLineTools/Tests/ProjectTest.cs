using AndroidCommandLineTools.Main;

namespace AndroidCommandLineTools.Tests;

public class ProjectTest
{

    [Fact]
    public void TestName()
    {
        Assert.Equal(expected: "AndroidCommandLineTools.Main", actual: Project.Name);
    }
}
