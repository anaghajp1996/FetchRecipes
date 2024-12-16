//
//  ImageCacheTests.swift
//  FetchRecipesTests
//
//  Created by Anagha K J on 15/12/24.
//

@testable import FetchRecipes
import XCTest

@MainActor
final class ImageCacheTests: XCTestCase {
    var imageCacheVM: ImageCacheVM!

    override func setUpWithError() throws {
        try super.setUpWithError()
        imageCacheVM = ImageCacheVM()
    }

    override func tearDownWithError() throws {
        imageCacheVM = nil
        try super.tearDownWithError()
    }

    func testCacheSuccess() async throws {
        let testImage = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        try await imageCacheVM.fetchImage(url: testImage)

        XCTAssertNotNil(imageCacheVM.image, "Image should be fetched successfully")
        XCTAssertNotNil(ImageCacheVM.cache.object(forKey: testImage.absoluteString as NSString), "Image should be cached")

        imageCacheVM.image = nil
        XCTAssertNotNil(ImageCacheVM.cache.object(forKey: testImage.absoluteString as NSString), "Image should still be cached")

        try await imageCacheVM.fetchImage(url: testImage)
        XCTAssertNotNil(imageCacheVM.image, "Image should be loaded from cache")
    }

    func testCacheFail() async throws {
        let testImage = URL(string: "https://test.jpg")!

        do {
            try await imageCacheVM.fetchImage(url: testImage)
        } catch {
            XCTAssertEqual(error as? ImageError, .unsupported, "Unsupported image format")
        }
    }
}
