import ProjectDescription
import ProjectDescriptionHelpers

func targets() -> [Target] {
    var targets: [Target] = []
    
    targets += Target.makeTargets(
        name: "Common",
        organizationName: "ss9",
        type: [.framework],
        dependencies: []
    )
    
    targets += Target.makeTargets(
        name: "UIKitExtension",
        organizationName: "ss9",
        type: [.framework],
        dependencies: [
            .target(name: "Common"),
            .external(name: "SnapKit")
        ]
    )
    
    targets += Target.makeTargets(
        name: "PagerTabBar",
        organizationName: "ss9",
        type: [.framework, .demo],
        dependencies: [
            .external(name: "SnapKit")
        ]
    )
    
    return targets
}

let project = Project(
    name: "UIComponent",
    targets: targets()
)
