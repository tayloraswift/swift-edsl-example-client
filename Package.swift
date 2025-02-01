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
    kkChecksum = "9c97bd6fe86c08294b57ae916f8511f31be7052db39e412af1694479cb4317bf"

case "Ubuntu-22.04-X64":
    kkChecksum = "750ae1cf47ab2c46e45e67746eb73a517ea43b48d009eaf33a7068842589c8e3"

case "Amazon-Linux-2-X64":
    kkChecksum = "41291f0560da794c27df18bbaf217a74305596865bb9128182d0f1156d90cf5f"

case "macOS-ARM64":
    kkChecksum = "8d367df3ea61e1213e1d15499118d5ceb408610ef62101d290193d86c868e958"

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
            2.0.0/\(kkPlatform)/main.artifactbundle.zip
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
