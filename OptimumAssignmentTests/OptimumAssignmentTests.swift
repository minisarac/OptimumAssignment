//
//  OptimumAssignmentTests.swift
//  OptimumAssignmentTests
//
//  Created by Deniz Sarac on 1/5/26.
//

import Foundation
@testable import OptimumAssignment
import Testing

struct OptimumAssignmentTests {
    @Test func trendingEndpointURLIsConstructedCorrectly() throws {
        let endpoint = Endpoint.trending(.movie, .day)
        let request = try endpoint.asURLRequest()
        let expectedURL = "https://api.themoviedb.org/3/trending/movie/day"
        #expect(request.url?.absoluteString == expectedURL)
    }

    @Test func movieDetailEndpointIncludesAppendToResponseParameters() throws {
        let endpoint = Endpoint.movieDetail(id: 123)
        let request = try endpoint.asURLRequest()
        let urlString = request.url?.absoluteString ?? ""
        #expect(urlString.contains("append_to_response=credits"))
        #expect(urlString.contains("release_dates"))
    }

    @Test func imageURLGeneratesCorrectTMDBImageURL() {
        let posterPath = "/abc123.jpg"
        let imageURL = Endpoint.imageURL(path: posterPath, size: .posterMedium)
        let expectedURL = "https://image.tmdb.org/t/p/w342/abc123.jpg"
        #expect(imageURL?.absoluteString == expectedURL)
    }
}
