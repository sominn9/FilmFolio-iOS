//
//  DIContainer.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class DIContainer {
    
    // MARK: - Properties
    
    static let shared = DIContainer()
    private let assembler: Assembler
    
    
    // MARK: - Init
    
    private init() {
        assembler = Assembler([
            DataSourceAssembly(),
            RepositoryAssembly(),
            ScreenAssembly()
        ])
    }
    
    
    // MARK: - Methods
    
    func resolve<T>() -> T {
        guard let service = assembler.resolver.resolve(T.self) else {
            fatalError()
        }
        return service
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T {
        guard let service = assembler.resolver.resolve(serviceType) else {
            fatalError()
        }
        return service
    }
    
    func resolve<T>(name: String?) -> T {
        guard let service = assembler.resolver.resolve(T.self, name: name) else {
            fatalError()
        }
        return service
    }
    
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let service = assembler.resolver.resolve(T.self, argument: argument) else {
            fatalError()
        }
        return service
    }
    
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let service = assembler.resolver.resolve(T.self, arguments: arg1, arg2) else {
            fatalError()
        }
        return service
    }
    
}
