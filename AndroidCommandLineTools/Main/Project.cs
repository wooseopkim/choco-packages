using System.Reflection;

namespace AndroidCommandLineTools.Main;


internal static class Project
{
    public static readonly string Name = Assembly.GetExecutingAssembly().GetName().Name!;
}
