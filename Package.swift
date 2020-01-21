// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "Scope",
	products: [
		.library(
			name: "Scope",
			targets: ["Scope"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/randymarsh77/idisposable", .branch("master")
		),
	],
	targets: [
		.target(
			name: "Scope",
			dependencies: ["IDisposable"]
		),
		.testTarget(
			name: "ScopeTests",
			dependencies: ["Scope"]
		),
	]
)
