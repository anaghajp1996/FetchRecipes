//
//  RecipesList.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import SwiftUI

struct RecipesList: View {
    @ObservedObject var recipesVM = RecipesVM()
    var body: some View {
        VStack {
            if recipesVM.error == nil {
                NavigationStack {
                    List(recipesVM.recipes, id: \.uuid) {
                        RecipeCard(recipe: $0)
                    }
                    .refreshable {
                        await recipesVM.getRecipes()
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Recipes")
                }
            } else {
                Text(recipesVM.error?.localizedDescription ?? "Something went wrong, please trya gain later.")
            }
        }
        .task {
            await recipesVM.getRecipes()
        }
    }
}

#Preview {
    RecipesList()
}