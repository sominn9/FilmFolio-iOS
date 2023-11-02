//
//  ScreenAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class ScreenAssembly: Assembly {
    
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            MovieHomeAssembly(),
            SeriesHomeAssembly(),
            MovieDetailAssembly(),
            SeriesDetailAssembly(),
            ReviewListAssembly(),
            ReviewAssembly(),
            UpcomingListAssembly(),
            SearchAssembly()
        ]
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
    }
    
}
