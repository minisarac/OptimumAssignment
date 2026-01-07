//
//  MediaContent.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

protocol MediaContent {
  var contentType: ContentType { get }
  var title: String { get }
  var year: String { get }
  var rating: String? { get }
}


