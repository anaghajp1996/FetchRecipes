//
//  RecipesList.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import SwiftUI

struct RecipesList: View {
    @ObservedObject var recipesVM = RecipesVM()
    @State var isLoading = false

    private func getRecipes() async {
        isLoading = true
        await recipesVM.getRecipes()
        isLoading = false
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if recipesVM.error == nil {
                    NavigationStack {
                        List(recipesVM.recipes, id: \.uuid) {
                            RecipeCard(recipe: $0)
                                .listRowSeparator(.hidden)
                        }
                        .refreshable {
                            await recipesVM.getRecipes()
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Recipes")
                    }
                } else {
                    ErrorScreen(message: recipesVM.error?.description ?? "Something went wrong, please try again later.")
                    Button("Retry", systemImage: "arrow.counterclockwise") {
                        Task {
                            await getRecipes()
                        }
                    }
                }
            }
        }
        .task {
            await getRecipes()
        }
    }
}

#Preview {
    RecipesList()
}
