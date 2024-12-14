//
//  Networking.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import Foundation

enum NetworkError: Error {
    case empty(String)
    case malformed(String)
}

class Networking {

    func getRequest() async throws -> Data {
        do {
            let url = URL(string: Constants.endPoint)!
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            if data.isEmpty {
                throw NetworkError.empty("Empty Data")
            }
            return data
        } catch {
            throw error
        }
    }
}
