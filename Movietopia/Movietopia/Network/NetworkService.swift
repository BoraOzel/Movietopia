//
//  NetworkService.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func fetchData(page: Int) async throws -> Movies?
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}
    
    var shouldFailOnce = true
    
    func fetchData<T: Codable>(page: Int) async throws -> T {
        if shouldFailOnce {
            shouldFailOnce = false
            throw URLError(.notConnectedToInternet)
        }
        let router = ApiRouter.popularMovies(page: page)
        let request = try router.request()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let movies = try JSONDecoder().decode(T.self, from: data)
        return movies
    }
}
