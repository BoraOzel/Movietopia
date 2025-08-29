//
//  NetworkHelper.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import Foundation

enum NetworkEndPoint: String {
    case baseUrl = "https://api.themoviedb.org/3"
    case baseImageUrl = "https://image.tmdb.org/t/p/w500/"
    case apiKey = "533106d280b301f294e6fbc565f8947a"
}

protocol NetworkHelperProtocol {
    func requestUrl(path: String) -> String
    func requestImageurl(path: String) -> String
}

class NetworkHelper: NetworkHelperProtocol {
    static let shared = NetworkHelper()
    
    private init() {}
    
    func requestUrl(path: String) -> String {
        return "\(NetworkEndPoint.baseUrl.rawValue)\(path)\(NetworkEndPoint.apiKey.rawValue)"
    }
    
    func requestImageurl(path: String) -> String {
        return "\(NetworkEndPoint.baseImageUrl.rawValue)\(path)"
    }
}
