//
//  ErrorScreen.swift
//  FetchRecipes
//
//  Created by Anagha K J on 13/12/24.
//

import SwiftUI

struct ErrorScreen: View {
    var message: String
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.octagon.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.yellow)
            Text(message)
                .multilineTextAlignment(.center)
                .font(.title2)
        }
        .padding()
    }
}

