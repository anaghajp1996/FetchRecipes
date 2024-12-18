//
//  RecipeCard.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    var body: some View {
        HStack {
            if let photoSmall = recipe.photoURLSmall {
                CachedImage(url: URL(string: photoSmall))
                .padding()
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            if let sourceURL = recipe.sourceURL {
                Button("", systemImage: "arrowshape.right") {
                    UIApplication.shared.open(URL(string: sourceURL)!)
                }
                .foregroundStyle(.black)
            }
        }
    }
}
