import ProjectDescription

let project = Project(
    name: "Utility",
    targets: [
        Target(
            name: "FoundationExtension",
            platform: .iOS,
            product: .framework,
            bundleId: "com.ss9.foundation-extension",
            infoPlist: .default,
            sources: ["Foundation Extension/Sources/**"],
            resources: []
        )
    ]
)
