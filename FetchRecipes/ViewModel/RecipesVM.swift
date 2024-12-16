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
            let data = try await Networking().getRequest()
            let recipes = try JSONDecoder().decode(Recipes.self, from: data)
            if recipes.recipes.isEmpty {
                self.error = .empty
            } else {
                self.recipes = recipes.recipes
            }
        } catch {
            self.error = .malformed
        }
    }
}
