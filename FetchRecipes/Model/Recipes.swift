//
//  Recipes.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import Foundation

struct Recipes: Codable, Equatable {
    var recipes: [Recipe]
}

struct Recipe {
    var cuisine: String
    var name: String
    var photoURLLarge: String?
    var photoURLSmall: String?
    var uuid: String
    var sourceURL: String?
    var youtubeURL: String?
}

extension Recipe: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case cuisine, name, uuid
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
