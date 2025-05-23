//
//  NetworkService.swift
//  ToDo
//
//  Created by Matvey Kostukovsky on 5/20/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(for urlString: String) async throws -> T
}

public final class NetworkService: NetworkServiceProtocol {
    public static let shared = NetworkService()
    
    private let urlSession: URLSession
    
    private init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchData<T: Decodable>(for urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkServiceError.unableToCreateURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200 else {
            throw NetworkServiceError.badResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkServiceError.unableToDecodeData
        }
    }
}

enum NetworkServiceError: Error {
    case unableToCreateURL
    case badResponse
    case unableToDecodeData
}

