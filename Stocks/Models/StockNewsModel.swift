//
//  StockNewsModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/27/24.
//

import Foundation

struct NewsArticle: Codable {
    var category: String
    var datetime: TimeInterval
    var headline: String
    var id: Int
    var image: String
    var related: String
    var source: String
    var summary: String
    var url: String
    
    var formattedDateTime: String {
        let date = Date(timeIntervalSince1970: datetime)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}

// Define the struct to handle the array of news articles, if neede
