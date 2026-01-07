//
//  TrendingPeriod.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import Foundation

enum TrendingPeriod: String, CaseIterable {
    case day
    case week

    var label: String {
        switch self {
        case .day:
            "Today"
        case .week:
            "This Week"
        }
    }
}
