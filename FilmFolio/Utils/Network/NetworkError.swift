//
//  NetworkError.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/30.
//

import Foundation

enum NetworkError: Error {
    case decodeError
    case invalidStatusCode(Int)
    case nonHTTPResponse(URLResponse)
    case unknown
}
