using AngleSharp;
using System.IO.Abstractions;
using AndroidCommandLineTools.Main;

var config = Configuration.Default.WithDefaultLoader();
var context = BrowsingContext.New(config);
var address = "https://developer.android.com/studio";
var document = await context.OpenAsync(address);

var release = Documents.ParseRelease(document);

var fs = new FileSystem();
var assets = new ReadOnlyProjectDirectory(fs, "Assets");
var releases = new WriteOnlyProjectDirectory(fs, "Releases");
await Choco.GeneratePackage(input: assets, output: releases, release: release);
