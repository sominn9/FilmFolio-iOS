import ProjectDescription

let project = Project(
    name: "UIComponent",
    targets: [
        Target(
            name: "Common",
            platform: .iOS,
            product: .framework,
            bundleId: "com.ss9.uicomponent-common",
            infoPlist: .default,
            sources: ["Common/Sources/**"],
            resources: [],
            dependencies: []
        ),
        Target(
            name: "UIKitExtension",
            platform: .iOS,
            product: .framework,
            bundleId: "com.ss9.uikit-extension",
            infoPlist: .default,
            sources: ["UIKit Extension/Sources/**"],
            resources: [],
            dependencies: [
                .target(name: "Common"),
                .external(name: "SnapKit")
            ]
        ),
        Target(
            name: "PagerTabBar",
            platform: .iOS,
            product: .framework,
            bundleId: "com.ss9.pager-tab-bar",
            infoPlist: .default,
            sources: ["Pager Tab Bar/Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit")
            ]
        )
    ]
)
