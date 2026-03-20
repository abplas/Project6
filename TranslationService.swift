//
//  TranslationService.swift
//  Lab 6
//
//  Created by Abel Plascencia on 3/20/26.
//

import Foundation

struct TranslationResponse: Codable {
    let responseData: TranslationData
}

struct TranslationData: Codable {
    let translatedText: String
}

struct TranslationService {
    func translate(
        text: String,
        source: Language,
        target: Language
    ) async throws -> String {

        var components = URLComponents(string: "https://api.mymemory.translated.net/get")

        components?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(source.rawValue)|\(target.rawValue)")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(TranslationResponse.self, from: data)

        return decoded.responseData.translatedText
    }
}
