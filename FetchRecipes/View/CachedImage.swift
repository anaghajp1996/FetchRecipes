//
//  CachedImage.swift
//  FetchRecipes
//
//  Created by Anagha K J on 14/12/24.
//

import SwiftUI

struct CachedImage: View {
    var url: URL?
    @StateObject private var imageCache = ImageCacheVM()
    private let imageSize: CGFloat = 60
    var body: some View {
        HStack {
            if let image = imageCache.image {
                Image(uiImage: image)
                    .frame(width: imageSize, height: imageSize)
            } else {
                Rectangle()
                    .fill(.gray)
                    .frame(width: imageSize, height: imageSize)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .task {
            await getImage()
        }
    }

    private func getImage() async {
        do {
            try await imageCache.fetchImage(url: url)
        } catch {}
    }
}
