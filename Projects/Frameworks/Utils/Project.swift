import ProjectDescription

let project = Project(
    name: "Utils",
    targets: [
        Target(
            name: "Utils",
            platform: .iOS,
            product: .framework,
            bundleId: "com.ss9.utils",
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "SnapKit")
            ]
        )
    ]
)
