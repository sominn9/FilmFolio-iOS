//
//  ImageStorage.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/01.
//

import UIKit

final class ImageStorage {
    
    // MARK: Singleton
    
    static let shared = ImageStorage()

    
    // MARK: Properties
    
    private var cache = NSCache<NSString, UIImage>()
    
    var countLimit: Int = 100 {
        didSet { cache.countLimit = countLimit }
    }
    
    var totalByteLimit: Int = 50_000_000 { // 50MB
        didSet { cache.totalCostLimit = totalByteLimit }
    }
    
    
    // MARK: Initializing
    
    private init() {
        self.cache.countLimit = countLimit
        self.cache.totalCostLimit = totalByteLimit
    }
    
    
    // MARK: Methods
    
    func image(for urlString: String) async -> UIImage? {
        if let image = cache.object(forKey: urlString as NSString) {
            return image
        }
        
        guard let image = await loadImage(urlString) else {
            return nil
        }
        
        let bytesOfImage = image.pngData()?.count ?? 0
        cache.setObject(image, forKey: urlString as NSString, cost: bytesOfImage)
        return image
    }
    
    private func loadImage(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url)
        else {
            print("Couldn't load image - \(urlString)")
            return nil
        }
        
        let uiImage = UIImage(data: data)
        return uiImage
    }
    
}
