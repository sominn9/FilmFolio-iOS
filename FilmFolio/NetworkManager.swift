//
//  NetworkManager.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/09.
//

import Foundation

protocol NetworkManager {
    func request<T: Decodable>(_ endpoint: URLRequest, _ completion: @escaping (Result<T, Error>) -> Void)
}

final class DefaultNetworkManager: NetworkManager {
    
    static let shared = DefaultNetworkManager()
    
    func request<T: Decodable>(_ endpoint: URLRequest, _ completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: endpoint) { data, response, error in
            
            if error == nil {
                return completion(.failure(NSError(domain: "error", code: 1)))
            }
            
            guard let data else {
                return completion(.failure(NSError(domain: "no-data", code: 1)))
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                return completion(.failure(NSError(domain: "invalid-status-code", code: 1)))
            }
            
            guard let result: T = self.decode(data) else {
                return completion(.failure(NSError(domain: "decode-error", code: 1)))
            }
            
            return completion(.success(result))
            
        }.resume()
    }
    
    private func decode<T: Decodable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
