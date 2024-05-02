//
//  StockChartsModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/28/24.
//
import Foundation

struct StockChartsResponse: Codable {
    let v: Int
    let vw: Double
    let o: Double
    let c: Double
    let h: Double
    let l: Double
    let t: Int64
    let n: Int
}

extension StockChartsResponse {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(t / 1000))
    }
}

struct StockHourlyChartsResponse: Codable {
    let v: Int
    let vw: Double
    let o: Double
    let c: Double
    let h: Double
    let l: Double
    let t: Int64
    let n: Int          
}


