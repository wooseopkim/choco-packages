using System.Xml.Linq;

namespace AndroidCommandLineTools.Tests;

public class XElementsTest
{
    [Theory]
    [InlineData([true])]
    [InlineData([false])]
    public void TestUpsertChild(bool update)
    {
        var element = new XElement("foo");
        if (update)
        {
            element.Add(new XElement("answer"));
        }

        element.UpsertChild(key: "answer", value: "42");

        Assert.Equal(expected: "42", actual: element.Element("answer")?.Value);
    }
}
