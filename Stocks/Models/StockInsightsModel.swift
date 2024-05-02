//
//  StockInsightsModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/27/24.
//

import Foundation

struct StockRecommendation: Codable {
    var buy, hold, sell, strongBuy, strongSell: Int
    var period, symbol: String
}

struct InsiderSentimentData: Codable {
    var symbol: String
    var year, month, change: Int
    var mspr: Double
}

struct InsiderSentiments: Codable {
    var data: [InsiderSentimentData]
    var symbol: String
}

struct CompanyEarning: Codable {
    var actual, estimate, surprise, surprisePercent: Double
    var period: String
    var quarter: Int
    var year: Int
    var symbol: String
}

struct StockInsightsResponse: Codable {
    var stockRecommendations: [StockRecommendation]
    var insiderSentiments: InsiderSentiments
    var companyEarnings: [CompanyEarning]
}
