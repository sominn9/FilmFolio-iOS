//
//  Endpoint.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/12.
//

import Foundation

struct Endpoint {
    let method: Method
    let urlString: String
    let header: [String: String]
    let query: [String: String]
    let port: Int?
    let body: Data?
    
    init(method: Method, urlString: String, header: [String: String] = [:], query: [String: String] = [:], port: Int? = nil, body: Data? = nil) {
        self.method = method
        self.urlString = urlString
        self.header = header
        self.query = query
        self.port = port
        self.body = body
    }
}

extension Endpoint {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    func urlRequest() -> URLRequest {
        guard let url = url() else {
            fatalError("Error occurred at : URLComponents -> URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = header
        
        return urlRequest
    }
    
    private func url() -> URL? {
        guard var urlComponents = URLComponents(string: urlString) else {
            fatalError("Error occurred at : URLComponents")
        }
        
        let queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = queryItems
        urlComponents.port = port
        
        return urlComponents.url
    }
}
