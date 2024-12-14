//
//  RecipesVM.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import Foundation

class RecipesVM: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var error: NetworkError? = nil

    func getRecipes() async {
        self.error = nil
        do {
            let data = try await Networking().getRequest()
            let recipes = try JSONDecoder().decode(Recipes.self, from: data)
            if recipes.recipes.isEmpty {
                self.error = .empty("No eecipes found. Please try again.")
            } else {
                self.recipes = recipes.recipes
            }
        } catch {
            self.error = .malformed("Something went wrong. Please try again later.")
        }
    }
}
