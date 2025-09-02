//
//  NetworkService.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func request<T: Decodable>(_ route: ApiRouter) async throws -> T
    func fetchMovies(page: Int) async throws -> Movies
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}
    
    func request<T: Decodable>(_ route: ApiRouter) async throws -> T {
        let request = try route.request()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchMovies(page: Int) async throws -> Movies {
        try await request(.popularMovies(page: page))
    }
    
}
