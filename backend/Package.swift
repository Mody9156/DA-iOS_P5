
// swift-tools-version:5.7.1

import PackageDescription

let package = Package(
    name: "backend",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
       
    ],
    products: [
        .library(name: "AWSLambdaPackager", targets: ["AWSLambdaPackager"]),
    ],
    dependencies: [
        // vos dépendances
        .package(url: "https://github.com/vapor/vapor.git", from: "4.76.0"),
    ],
    targets: [
        .executableTarget(
                   name: "App",
                   dependencies: [
                       .product(name: "Vapor", package: "vapor")
                   ]
               ),
        .target(
            name: "AWSLambdaPackager",
            dependencies: [
                // vos dépendances de la cible
            ],
            path: "Plugins/AWSLambdaPackager"
        )
    ]
)
