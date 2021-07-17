// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "GLib",
    products: [ .library(name: "GLib", targets: ["GLib"]) ],
    dependencies: [
        .package(name: "gir2swift", url: "https://github.com/rhx/gir2swift.git", .branch("main"))
    ],
    targets: [
        .systemLibrary(name: "CGLib", pkgConfig: "gio-unix-2.0",
            providers: [
                .brew(["glib", "glib-networking", "gobject-introspection"]),
                .apt(["libglib2.0-dev", "glib-networking", "gobject-introspection", "libgirepository1.0-dev"])
            ]),
        .target(
            name: "GLib", 
            dependencies: ["CGLib"],
            swiftSettings: [.unsafeFlags(["-Xfrontend", "-serialize-debugging-options"], .when(configuration: .debug))],
            plugins: [.plugin(name: "Gir2SwiftPlugin", package: "gir2swift")]
        ),
        .testTarget(name: "GLibTests", dependencies: ["GLib"]),
    ]
)
