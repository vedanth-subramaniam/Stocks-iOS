//
//  StockSummaryModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/22/24.
//
import Foundation

// Define the root of the JSON response
struct StockSummaryResponse: Codable {
    let stockProfile: StockProfile
    let latestPrice: LatestPrice
    let companyPeers: [String]
}

// Define each nested object in the JSON
struct StockProfile: Codable {
    let country: String?
    let currency: String?
    let estimateCurrency: String?
    let exchange: String?
    let finnhubIndustry: String?
    let ipo: String?
    let logo: URL?
    let marketCapitalization: Double?
    let name: String?
    let phone: String?
    let shareOutstanding: Double?
    let ticker: String?
    let weburl: URL
}

struct LatestPrice: Codable {
    let c: Double?  // Current price
    let d: Double?  // Change
    let dp: Double? // Change percent
    let h: Double?  // High price of the day
    let l: Double?  // Low price of the day
    let o: Double?  // Opening price of the day
    let pc: Double? // Previous close price
    let t: Int?     // Timestamp
}
