//
//  StockDetailsView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import SwiftUI

struct StockDetailsView: View {
    
    var stock: StockTicker
    
    @State private var stockSummaryResponse: StockSummaryResponse?
    @State private var stockInsightsResponse: StockInsightsResponse?
    @State private var stockNewsReponse: [NewsArticle]?
    @State private var stockChartsResponse: [StockChartsResponse]?
    @State private var stockHourlyChartsResponse: [StockHourlyChartsResponse]?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading){
                    Text(stock.symbol)
                        .font(.title2)
                        .bold()
                    
                    Text(stockSummaryResponse?.stockProfile.name ?? "Apple")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack() {
                        Text(String(format: "$%.2f", stockSummaryResponse?.latestPrice.c ?? 0))
                            .font(.largeTitle)
                            .bold()
                        HStack(spacing: 2) {
                            Text(String(format: "$%.2f", stockSummaryResponse?.latestPrice.dp ?? 0))
                            Text(String(format: "(%.2f%%)", stockSummaryResponse?.latestPrice.pc ?? 0))
                        }
                        .foregroundColor(stockSummaryResponse?.latestPrice.pc ?? 0 < 0 ? .red : .green)
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
            fetchNewsDetails()
            fetchCharts()
            fetchHourlyCharts()
        }
    }
    
    func fetchSummaryDetails(){
        ApiService.shared.fetchStockData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockSummaryResponse = results
                } else {
                    print("Error fetching stock summary data: \(error?.localizedDescription ?? "Unknown error")")
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
                    print("Error fetching company insights data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func fetchNewsDetails(){
        ApiService.shared.fetchNewsData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockNewsReponse = results
                } else {
                    print("Error fetching news data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func fetchCharts(){
        print("Charts")
        ApiService.shared.fetchChartsData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockChartsResponse = results
                } else {
                    print("Error fetching charts history data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func fetchHourlyCharts(){
        print("Hourly")
        ApiService.shared.fetchHourlyChartsData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockHourlyChartsResponse = results
                } else {
                    print("Error fetching hourly charts data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
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

//#Preview {
//    StockDetailsView(stock: StockTicker(symbol: "TSLA"))
//}
