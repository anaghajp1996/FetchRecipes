//
//  NetworkTests.swift
//  FetchRecipesTests
//
//  Created by Anagha K J on 17/12/24.
//

@testable import FetchRecipes
import XCTest

@MainActor
final class NetworkTests: XCTestCase {
    var networkVM: Networking?
    var recipedVM: RecipesVM?

    override func setUpWithError() throws {
        networkVM = Networking()
    }

    override func tearDownWithError() throws {
        networkVM = nil
    }

    func testNetworkCall() async throws {
        let data = try await networkVM?.getRequest(endPoint: Constants.endPoint)
        // This will fail when this endpoint itself retruns malformed or empty data
        XCTAssertNotNil(data, "Successful API call")
        do {
            let _ = try await networkVM?.getRequest(endPoint: Constants.emptyEndPoint)
        } catch {
            XCTAssertEqual(error as? NetworkError, .empty, "Empty Data")
        }
        do {
            let _ = try await networkVM?.getRequest(endPoint: Constants.malformedEndPoint)
        } catch {
            XCTAssertEqual(error as? NetworkError, .malformed, "Malformed Data")
        }
    }

    func testDataConversion() async throws {
        let recipesVM = RecipesVM()
        let rightData = """
        {
            "recipes": [
                {
                    "cuisine": "British",
                    "name": "Bakewell Tart",
                    "photo_url_large": "https://some.url/large.jpg",
                    "photo_url_small": "https://some.url/small.jpg",
                    "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                    "source_url": "https://some.url/index.html",
                    "youtube_url": "https://www.youtube.com/watch?v=some.id"
                },
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
            ]
        }
        """
        let rightConversion = recipesVM.convertData(from: rightData.data(using: .utf8)!)
        let rightRecipes = Recipes(recipes: [
            Recipe(cuisine: "British", name: "Bakewell Tart", photoURLLarge: "https://some.url/large.jpg", photoURLSmall: "https://some.url/small.jpg", uuid: "eed6005f-f8c8-451f-98d0-4088e2b40eb6", sourceURL: "https://some.url/index.html", youtubeURL: "https://www.youtube.com/watch?v=some.id"),
            Recipe(cuisine: "Malaysian", name: "Apam Balik", photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        ])
        XCTAssertEqual(rightConversion, rightRecipes, "Convertion to Recipe model should be correct")

        let malformedData = """
        {
            "recipes": [
                {
                    "cuisi": "British",
                    "photo_url_large": "https://some.url/large.jpg",
                    "photo_url_small": "https://some.url/small.jpg",
                    "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                    "source_url": "https://some.url/index.html",
                    "youtube_url": "https://www.youtube.com/watch?v=some.id"
                },
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
            ]
        }
        """
        let _ = recipesVM.convertData(from: malformedData.data(using: .utf8)!)
        XCTAssertEqual(recipesVM.error, .malformed, "Convertion to Recipe model should fail and error set to .malformed")
        
        let emptyData = """
        {
            "recipes": []
        }
        """
        let emptyConversion = recipesVM.convertData(from: emptyData.data(using: .utf8)!)
        XCTAssertEqual(emptyConversion, Recipes(recipes: []), "Convertion to Recipe model succeed and recipes must be an empty array")
    }
}
