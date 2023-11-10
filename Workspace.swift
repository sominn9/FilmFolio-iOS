import ProjectDescription

let workspace = Workspace(
    name: "Workspace",
    projects: [
        .relativeToManifest("Projects/Application"),
        .relativeToManifest("Projects/Frameworks/**")
    ]
)
