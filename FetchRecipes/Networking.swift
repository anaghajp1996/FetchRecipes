//
//  Networking.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import Foundation

enum NetworkError: Error {
    case empty
    case malformed
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "No recipes found!"
        case .malformed:
            return "Oops! Something went wrong, please try again later."
        }
    }
}

class Networking {
    func getRequest(endPoint: String) async throws -> Data {
        do {
            let url = URL(string: endPoint)!
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            if data.isEmpty {
                throw NetworkError.empty
            }
            return data
        } catch {
            throw NetworkError.malformed
        }
    }
}
