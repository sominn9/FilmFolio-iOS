//
//  File.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/28.
//

import CoreData
import Foundation

private var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

extension ReviewEntity {
    func toDomain() -> Review {
        .init(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            content: self.content ?? "",
            posterPath: self.posterPath,
            publishDate: formatter.string(from: self.publishDate ?? Date())
        )
    }
}

extension Review {
    func toEntity(in context: NSManagedObjectContext) -> NSManagedObject {
        let entity = ReviewEntity(context: context)
        entity.id = self.id
        entity.title = self.title
        entity.content = self.content
        entity.posterPath = self.posterPath
        entity.publishDate = formatter.date(from: self.publishDate)
        return entity
    }
}
