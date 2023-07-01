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
    
    private init() { }
    
    
    // MARK: Properties
    
    private var images = NSCache<NSString, UIImage>()
    
    
    // MARK: Methods
    
    func image(for urlString: String) async -> UIImage? {
        
        if let image = images.object(forKey: urlString as NSString) {
            return image
        }
        
        guard let image = await loadImage(urlString) else {
            return nil
        }
        
        images.setObject(image, forKey: urlString as NSString)
        return image
    }
    
}

private extension ImageStorage {
    
    func loadImage(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            print("Couldn't load image - \(urlString)")
            return nil
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
    
}
