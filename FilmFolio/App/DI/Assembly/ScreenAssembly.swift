//
//  ScreenAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class ScreenAssembly: Assembly {
    
    func assemble(container: Container) {
        let asseblies: [Assembly] = [
            MovieDetailAssembly(),
            SeriesDetailAssembly()
        ]
        for assebly in asseblies {
            assebly.assemble(container: container)
        }
    }
    
}
