//
//  Stock.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import Foundation

struct Stock: Identifiable, Decodable {
    var id: String
    var symbol: String
    var companyName: String
    var price: String
    var change: String
    var isPositive: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"  // Mapping "_id" from JSON to "id" in Swift
        case symbol
        case companyName
        case price
        case change
        case isPositive
    }
}

struct StockAutocomplete: Codable {
    var description: String
    var displaySymbol: String
    var symbol: String
    var type: String
    var primary: [String]?

    enum CodingKeys: String, CodingKey {
        case description
        case displaySymbol
        case symbol
        case type
        case primary
    }
}
