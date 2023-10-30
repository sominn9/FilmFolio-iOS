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
        
        URLSession.shared.dataTask(with: endpoint.urlRequest()) { [weak self] data, response, error in
            
            do {
                guard let self = self else { return }
                let data = try handle(data, response, error)
                let result: T = try decode(data)
                completion(.success(result))
                
            } catch {
                debugPrint(error)
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func request<T>(_ endpoint: Endpoint) -> Observable<Result<T, Error>> where T: Decodable {
        
        return URLSession.shared.rx.response(request: endpoint.urlRequest())
            .map { [weak self] (response: HTTPURLResponse, data: Data) in
                
                guard (200..<300) ~= response.statusCode else {
                    let code = response.statusCode
                    throw NetworkError.invalidStatusCode(code)
                }
                
                guard let result: T = try self?.decode(data) else {
                    throw NetworkError.unknown
                }
                
                return Result.success(result)
            }
            .catch {
                debugPrint($0)
                return Observable.just(Result.failure($0))
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
    
}

private extension DefaultNetworkManager {
    
    func handle(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Data {
        
        if let error = error {
            throw error
        }
        
        guard let response = response, let data = data else {
            throw NetworkError.unknown
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTPResponse(response)
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
            let code = httpResponse.statusCode
            throw NetworkError.invalidStatusCode(code)
        }
        
        return data
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
}
