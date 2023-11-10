import ProjectDescription

let project = Project(
    name: "Application",
    targets: [
        Target(
            name: "Application",
            platform: .iOS,
            product: .app,
            bundleId: "com.ss9.film-folio",
            infoPlist: "Configuration/Info.plist",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Utils", path: "../Frameworks/Utils"),
                .external(name: "SnapKit"),
                .external(name: "Swinject"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ],
            coreDataModels: [
                CoreDataModel("Sources/Data/Infrastructure/CoreData/Model.xcdatamodeld")
            ]
        )
    ]
)
