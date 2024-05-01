//
//  Stock.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import Foundation

struct StockPortfolio: Codable {
    var ticker: String
    var quantity: Double
    var totalCost: Double
    var averagePrice: Double
    var price: Double
    var marketValue: Double
    var changePrice: Double
    var changePricePercent: String
    var isPositive: Bool
}

struct StockWishlist: Codable {
    var ticker: String
    var companyName: String
    var price: Double
    var changePrice: Double
    var changePricePercent: String
    var isPositive: Bool
}

struct StockPortfolioDb: Codable {
    var ticker: String
    var quantity: Double
    var totalCost: Double
}

struct StockWishlistDb: Codable {
    var ticker: String
    var companyName: Double
}
struct StockTicker: Codable {
    var ticker: String
}

struct StockAutocomplete: Codable {
    var id: String?
    var description: String
    var displaySymbol: String
    var symbol: String
    var type: String
    var primary: [String]?
}

struct StockWalletBalance: Codable{
    var balance: Double
}

struct ApiResponse: Decodable {
    var success: Bool?
    var message: String
}
