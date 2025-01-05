using System.Xml.Linq;

namespace AndroidCommandLineTools.Main;

internal static class XElements
{

    public static void UpsertChild(this XElement element, string key, string value)
    {
        var name = element.GetDefaultNamespace() + key;
        var target = element.Element(name);
        if (target != null)
        {
            target.SetValue(value);
            return;
        }
        var child = new XElement(name, value);
        element.Add(child);
    }
}
