import ProjectDescription

public enum TargetType {
    case framework
    case testing
    case tests
    case demo
    case interface
}

extension Target {
    
    public static func makeTargets(
        name: String,
        organizationName: String,
        type: Set<TargetType> = [.framework, .testing, .tests, .demo, .interface],
        dependencies: [TargetDependency] = [],
        path: String = "" // "Projects/Frameworks/"
    ) -> [Target] {
        
        let path = path.isEmpty ? "" : (path.last! == "/" ? path : path + "/")
        var targets = [Target]()
        
        if type.contains(.interface) {
            let target = Target(
                name: "\(name)Interface",
                platform: .iOS,
                product: .framework,
                bundleId: "com.\(organizationName).\(name)Interface",
                infoPlist: .default,
                sources: ["\(path)\(name)/Interface/**"],
                dependencies: dependencies
            )
            targets.append(target)
        }
        
        if type.contains(.framework) {
            var frameworkDependencies: [TargetDependency] = []
            
            if type.contains(.interface) {
                frameworkDependencies =  [.target(name: "\(name)Interface")]
            } else {
                frameworkDependencies = dependencies
            }
            
            let target = Target(
                name: name,
                platform: .iOS,
                product: .framework,
                bundleId: "com.\(organizationName).\(name)",
                infoPlist: .default,
                sources: ["\(path)\(name)/Sources/**"],
                dependencies: frameworkDependencies
            )
            targets.append(target)
        }
        
        if type.contains(.testing) {
            var testingDependencies: [TargetDependency] = [.xctest]
            
            if type.contains(.interface) {
                testingDependencies.append(.target(name: "\(name)Interface"))
            } else {
                testingDependencies.append(.target(name: name))
            }
            
            let target = Target(
                name: "\(name)Testing",
                platform: .iOS,
                product: .framework,
                bundleId: "com.\(organizationName).\(name)Testing",
                infoPlist: .default,
                sources: ["\(path)\(name)/Testing/**"],
                dependencies: testingDependencies
            )
            targets.append(target)
        }
        
        if type.contains(.tests) {
            let target = Target(
                name: "\(name)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "com.\(organizationName).\(name)Tests",
                infoPlist: .default,
                sources: ["\(path)\(name)/Tests/**"],
                dependencies: [.target(name: name), .target(name: "\(name)Testing")]
            )
            targets.append(target)
        }
        
        if type.contains(.demo) {
            var exampleDependencies : [TargetDependency] = [.target(name: name)]
            
            if type.contains(.testing) {
                exampleDependencies.append(.target(name: "\(name)Testing"))
            }
            
            let target = Target(
                name: "\(name)Demo",
                platform: .iOS,
                product: .app,
                bundleId: "com.\(organizationName).\(name)Demo",
                infoPlist: .extendingDefault(with: [
                    "CFBundleShortVersionString": "1.0",
                    "CFBundleVersion": "1",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [[
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]]
                        ]
                    ]
                ]),
                sources: ["\(path)\(name)/Demo/Sources/**"],
                resources: ["\(path)\(name)/Demo/Resources/**"],
                dependencies: exampleDependencies
            )
            targets.append(target)
        }
        
        return targets
    }
    
}
