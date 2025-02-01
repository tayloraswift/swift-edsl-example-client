// swift-tools-version:6.0
import Foundation
import PackageDescription

guard
let kkPlatform:String = ProcessInfo.processInfo.environment["SWIFTPM_KK_PLATFORM"]
else
{
    fatalError("Missing environment variable: SWIFTPM_KK_PLATFORM")
}

let kkChecksum:String

switch kkPlatform
{
case "Ubuntu-24.04-X64":
    kkChecksum = "ff0a948cb110ae402e152ca3461570ef909d44c29cbeef2411a11de7b8805d9b"

case "Ubuntu-22.04-X64":
    kkChecksum = "f9cd285801b84c935c512be3879c440dedfeb191882a72c247a17dae147557fa"

case "Amazon-Linux-2-X64":
    kkChecksum = "ca40ccb4a349f76aa5f4a5b4de97493fe65f94b9e67973e543ea1365c796173a"

case "macOS-ARM64":
    kkChecksum = "8079612425e3b8f550207226cbc7fac51818b9010982e7134ab2be068dcee61a"

default:
    fatalError("Unsupported platform: \(kkPlatform)")
}

let package:Package = .init(name: "swift-rlp-example-client",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .visionOS(.v2), .watchOS(.v11)],
    products: [
        .executable(name: "KrustyKrab", targets: ["KrustyKrab"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "KrabbyPatty",
            url: """
            https://download.swiftinit.org/swift-rlp-example/\
            3.0.0/\(kkPlatform)/main.artifactbundle.zip
            """,
            checksum: kkChecksum),

        .executableTarget(name: "KrustyKrab",
            dependencies: [
                .target(name: "KrabbyPatty"),
            ]),
    ]
)

for target:PackageDescription.Target in package.targets
{
    {
        guard case .regular = target.type
        else
        {
            return
        }

        var settings:[PackageDescription.SwiftSetting] = $0 ?? []

        settings.append(.enableUpcomingFeature("ExistentialAny"))
        settings.append(.enableExperimentalFeature("StrictConcurrency"))

        $0 = settings
    } (&target.swiftSettings)
}
