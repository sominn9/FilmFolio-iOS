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
            dependencies: [
                .project(target: "Resource", path: "../Frameworks/Resource"),
                .project(target: "FoundationExtension", path: "../Frameworks/Utility"),
                .project(target: "Common", path: "../Frameworks/UIComponent"),
                .project(target: "UIKitExtension", path: "../Frameworks/UIComponent"),
                .project(target: "PagerTabBar", path: "../Frameworks/UIComponent"),
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
