//
//  ImageCacheVM.swift
//  FetchRecipes
//
//  Created by Anagha K J on 14/12/24.
//

import Foundation
import UIKit

enum ImageError: Error {
    case badRequest, unsupported
}

@MainActor
class ImageCacheVM: ObservableObject {
    @Published var image: UIImage?
    static let cache = NSCache<NSString, UIImage>()

    func fetchImage(url: URL?) async throws {
        if let url = url {
            if let cachedImage = Self.cache.object(forKey: url.absoluteString as NSString) {
                image = cachedImage
            } else {
                let request = URLRequest(url: url)
                do {
                    let (data, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw ImageError.badRequest
                    }
                    if httpResponse.statusCode == 200 {
                        guard let image = UIImage(data: data) else {
                            throw ImageError.unsupported
                        }
                        Self.cache.setObject(image, forKey: url.absoluteString as NSString)
                        self.image = image
                    } else {
                        throw ImageError.unsupported
                    }
                } catch {
                    throw ImageError.unsupported
                }
            }
        } else {
            throw ImageError.unsupported
        }
    }
}
