// swift-tools-version:6.0
import PackageDescription

let package = Package(
	name: "Scope",
	products: [
		.library(
			name: "Scope",
			targets: ["Scope"]
		)
	],
	dependencies: [
		.package(
			url: "https://github.com/randymarsh77/idisposable",
			branch: "master"
		)
	],
	targets: [
		.target(
			name: "Scope",
			dependencies: [.product(name: "IDisposable", package: "IDisposable")]
		),
		.testTarget(
			name: "ScopeTests",
			dependencies: ["Scope"]
		),
	]
)
