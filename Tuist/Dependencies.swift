import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: SwiftPackageManagerDependencies([
        .remote(
            url: "https://github.com/SnapKit/SnapKit",
            requirement: .upToNextMajor(from: "5.0.0")
        ),
        .remote(
            url: "https://github.com/ReactiveX/RxSwift",
            requirement: .exact("6.6.0")
        ),
        .remote(
            url: "https://github.com/Swinject/Swinject",
            requirement: .upToNextMajor(from: "2.0.0")
        )
    ]),
    platforms: [.iOS]
)
