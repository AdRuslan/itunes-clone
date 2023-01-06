//
//  NetworkController.swift
//  ITunes Clone
//
//  Created by Руслан Адигамов on 05.01.2023.
//

import Foundation

class NetworkController {
    static func loadMusic(song: String) async throws -> ServerResponce {
        let scheme = "https"
        let host = "itunes.apple.com"
        let path = "/search"
        let term = URLQueryItem(name: "term", value: song)
        let country = URLQueryItem(name: "country", value: "RU")

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [term,country]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        let urlRequest = URLRequest(url: url)
        let task = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let result = try decoder.decode(ServerResponce.self, from: task.0)
        return result
    }
    static func loadImage(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let urlRequest = URLRequest(url: url)
        let task = try await URLSession.shared.data(for: urlRequest)
        return task.0
    }
}
