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
    formatter.dateFormat = DateFormat.reviewFormat
    return formatter
}()

extension ReviewEntity {
    func toDomain() -> Review {
        guard let media = Media(rawValue: self.media ?? "") else {
            fatalError("Unregistered media type detected - \(self.media ?? "")")
        }
        
        return Review(
            id: Int(self.id),
            media: media,
            title: self.title ?? "",
            content: self.content ?? "",
            posterURL: URL(string: self.posterURLString ?? ""),
            publishDate: formatter.string(from: self.publishDate ?? Date())
        )
    }
}

extension Review {
    func toEntity(in context: NSManagedObjectContext) -> NSManagedObject {
        let entity = ReviewEntity(context: context)
        entity.id = Int32(self.id)
        entity.media = self.media.rawValue
        entity.title = self.title
        entity.content = self.content
        entity.posterURLString = self.posterURL?.absoluteString
        entity.publishDate = formatter.date(from: self.publishDate)
        return entity
    }
}
