import PackageDescription

let package = Package(
    name: "Scope",
    dependencies: [
		.Package(url: "https://www.github.com/randymarsh77/idisposable", majorVersion: 1),
	]
)
