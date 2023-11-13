import ProjectDescription

let template = Template(
    description: "App template",
    attributes: [],
    items: [
        .file(
            path: "Sources/AppDelegate.swift",
            templatePath: "../AppDelegate.stencil"
        ),
        .file(
            path: "Sources/SceneDelegate.swift",
            templatePath: "../SceneDelegate.stencil"
        ),
        .file(
            path: "Resources/LaunchScreen.storyboard",
            templatePath: "../LaunchScreen.stencil"
        )
    ]
)
