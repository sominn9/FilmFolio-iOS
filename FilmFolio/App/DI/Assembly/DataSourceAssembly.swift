//
//  DataSourceAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class DataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CoreDataStorage.self) { _ in
            return CoreDataStorage.shared
        }
        
        container.register(NetworkManager.self) { _ in
            return DefaultNetworkManager.shared
        }
    }
}
