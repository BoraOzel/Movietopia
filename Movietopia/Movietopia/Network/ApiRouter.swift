//
//  ApiRouter.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import Foundation

enum ApiRouter {
    case popularMovies(page: Int)
    case ImageUrl(path: String)
}

extension ApiRouter {
    var baseUrl: String { "https://api.themoviedb.org/3" }
    var baseImageUrl : String { "https://image.tmdb.org/t/p/w500/" }
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .ImageUrl(path: let path):
            return "\(baseImageUrl)"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        let apiKey = "533106d280b301f294e6fbc565f8947a"
        switch self {
        case .popularMovies(let page):
            return [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .ImageUrl(path: let path):
            return [URLQueryItem(name: "", value: "\(path)")]
        }
    }
    
    func getImagePath() -> String {
        return (URLComponents(string: baseImageUrl + path)?.url)?.absoluteString ?? ""
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



