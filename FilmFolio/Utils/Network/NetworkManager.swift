//
//  NetworkManager.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/09.
//

import Foundation
import RxSwift

protocol NetworkManager {
    func request<T: Decodable>(_ endpoint: Endpoint, _ completion: @escaping (Result<T, Error>) -> Void)
    func request<T: Decodable>(_ endpoint: Endpoint) -> Observable<Result<T, Error>>
    func request<T>(_ endpoint: Endpoint) -> Observable<T> where T: Decodable
}

final class DefaultNetworkManager: NetworkManager {
    
    static let shared: NetworkManager = DefaultNetworkManager()
    
    func request<T>(_ endpoint: Endpoint, _ completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        
        URLSession.shared.dataTask(with: endpoint.urlRequest()) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.nonHTTPResponse(response)))
                return
            }
            
            guard (200..<300) ~= httpResponse.statusCode else {
                let code = httpResponse.statusCode
                completion(.failure(NetworkError.invalidStatusCode(code)))
                return
            }
            
            guard let result: T = self.decode(data) else {
                completion(.failure(NetworkError.decodeError))
                return
            }
            
            return completion(.success(result))
            
        }.resume()
    }
    
    func request<T>(_ endpoint: Endpoint) -> Observable<Result<T, Error>> where T: Decodable {
        
        return URLSession.shared.rx.response(request: endpoint.urlRequest())
            .map { [weak self] (response: HTTPURLResponse, data: Data) in
                
                guard (200..<300) ~= response.statusCode else {
                    let code = response.statusCode
                    return Result.failure(NetworkError.invalidStatusCode(code))
                }
                
                guard let result: T = self?.decode(data) else {
                    return Result.failure(NetworkError.decodeError)
                }
                
                return Result.success(result)
            }
            .catch {
                Observable.just(Result.failure($0))
            }
    }
    
    func request<T>(_ endpoint: Endpoint) -> Observable<T> where T: Decodable {
        
        return request(endpoint)
            .map { (result: Result<T, Error>) in
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    throw error
                }
            }
    }
    
    private func decode<T: Decodable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
