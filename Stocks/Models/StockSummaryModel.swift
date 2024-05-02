//
//  StockSummaryModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/22/24.
//
import Foundation

struct StockSummaryResponse: Codable {
    let stockProfile: StockProfile
    let latestPrice: LatestPrice
    let companyPeers: [String]
}

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
    let c: Double?
    let d: Double?
    let dp: Double?
    let h: Double?
    let l: Double?
    let o: Double?
    let pc: Double?
    let t: Int?
}
