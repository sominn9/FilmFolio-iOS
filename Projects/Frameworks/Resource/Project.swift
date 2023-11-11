import ProjectDescription

let project = Project(
    name: "Resource",
    targets: [
        Target(
            name: "Resource",
            platform: .iOS,
            product: .framework,
            bundleId: "com.ss9.resource",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        )
    ]
)
