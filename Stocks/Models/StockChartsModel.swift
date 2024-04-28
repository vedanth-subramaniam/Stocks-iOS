//
//  StockChartsModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/28/24.
//
import Foundation

// Define a struct for the JSON response
struct StockChartsResponse: Codable {
    let v: Int           // Volume
    let vw: Double       // Volume Weighted Average Price
    let o: Double        // Opening price
    let c: Double        // Closing price
    let h: Double        // High price
    let l: Double        // Low price
    let t: Int64         // Timestamp (milliseconds since Unix epoch)
    let n: Int           // Number of transactions
}

extension StockChartsResponse {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(t / 1000))
    }
}

struct StockHourlyChartsResponse: Codable {
    let v: Int           // Volume
    let vw: Double       // Volume Weighted Average Price
    let o: Double        // Opening price
    let c: Double        // Closing price
    let h: Double        // High price
    let l: Double        // Low price
    let t: Int64         // Timestamp (milliseconds since Unix epoch)
    let n: Int           // Number of transactions
}


