//
//  ApiRouter.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import Foundation

enum ApiRouter {
    case popularMovies(page: Int)
}

extension ApiRouter {
    var baseUrl: String { "https://api.themoviedb.org/3" }
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        switch self {
        case .popularMovies(let page):
            return [
                URLQueryItem(name: "api_key", value: NetworkEndPoint.apiKey.rawValue),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
    
    func request() throws -> URLRequest {
        var components = URLComponents(string: baseUrl + path)
        components?.queryItems = queryParameters
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

