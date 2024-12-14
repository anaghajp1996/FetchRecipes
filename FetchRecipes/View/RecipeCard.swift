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
                AsyncImage(url: URL(string: photoSmall)) { image in
                    image
                        .resizable()
                        .frame(width: 70, height: 70)
                } placeholder: {
                    ProgressView()
                }
                .padding()
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

#Preview {
    RecipeCard(recipe: Recipe(cuisine: "Indian",
                              name: "Buttuh Chicken",
                              photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                              uuid: "qwertyuioplkjhgfdsa"))
}
