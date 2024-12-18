//
//  RecipesVM.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import Foundation

@MainActor
class RecipesVM: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var error: NetworkError? = nil

    func getRecipes() async {
        self.error = nil
        do {
            let data = try await Networking().getRequest(endPoint: Constants.endPoint)
            let recipes = convertData(from: data)
            if let recipes = recipes {
                if recipes.recipes.isEmpty {
                    self.error = .empty
                } else {
                    self.recipes = recipes.recipes
                }
            } else {
                self.error = .malformed
            }
        } catch {
            self.error = .malformed
        }
    }
    
    func convertData(from data: Data) -> Recipes? {
        var recipes: Recipes?
        do {
            return try JSONDecoder().decode(Recipes.self, from: data)
        } catch {
            self.error = .malformed
        }
        return recipes
    }
}
