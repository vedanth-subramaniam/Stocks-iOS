//
//  StockDetailsView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import SwiftUI

struct StockDetailsView: View {
    
    var stock: StockTicker
    @State private var stockSummaryDetails: StockSummaryAPIResponse?
    @State private var stockInsightsResponse: StockInsightsResponse?
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading){
                    Text(stock.symbol)
                        .font(.title2)
                        .bold()
                    
                    Text(stockSummaryDetails?.stockProfile.name ?? "Apple")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack() {
                        Text(String(format: "$%.2f", stockSummaryDetails?.latestPrice.c ?? 0))
                            .font(.largeTitle)
                            .bold()
                        HStack(spacing: 2) {
                            Text(String(format: "$%.2f", stockSummaryDetails?.latestPrice.dp ?? 0))
                            Text(String(format: "(%.2f%%)", stockSummaryDetails?.latestPrice.pc ?? 0))
                        }
                        .foregroundColor(stockSummaryDetails?.latestPrice.pc ?? 0 < 0 ? .red : .green)
                    }
                }

                ChartPlaceholderView()
                    .frame(height: 200)
                    .padding([.top, .horizontal])
                
                PortfolioView(sharesOwned: 3, averageCost: 171.23)
            }
        }
        .onAppear() {
            fetchSummaryDetails()
            fetchCompanyInsights()
        }
    }
    
    func fetchSummaryDetails(){
        ApiService.shared.fetchStockData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockSummaryDetails = results
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func fetchCompanyInsights(){
        ApiService.shared.fetchInsightsData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockInsightsResponse = results
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
//    func fetchNewsDetails(){
//        ApiService.shared.fetchStockData(query: stock.symbol) { results, error in
//            DispatchQueue.main.async {
//                if let results = results {
//                    self.stockSummaryDetails = results
//                } else {
//                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }
//    }
//    
//    func fetchCharts(){
//        ApiService.shared.fetchStockData(query: stock.symbol) { results, error in
//            DispatchQueue.main.async {
//                if let results = results {
//                    self.stockSummaryDetails = results
//                } else {
//                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }
//    }
//    
//    func fetchChartsHourly(){
//        ApiService.shared.fetchStockData(query: stock.symbol) { results, error in
//            DispatchQueue.main.async {
//                if let results = results {
//                    self.stockSummaryDetails = results
//                } else {
//                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }
//    }
}

struct ChartPlaceholderView: View {
    var body: some View {
        Text("Chart View Placeholder")
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

struct PortfolioView: View {
    let sharesOwned: Int
    let averageCost: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Portfolio")
                .font(.headline)
                .padding(.vertical, 4)
            HStack {
                VStack(alignment: .leading) {
                    Text("Shares Owned:")
                    Text("Avg. Cost / Share:")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(sharesOwned)")
                    Text(String(format: "$%.2f", averageCost))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            // Dummy progress bar
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .frame(height: 6)
                .padding(.horizontal)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    StockDetailsView(stock: StockTicker(symbol: "TSLA"))
}
