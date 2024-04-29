//
//  StockDetailsView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//
import SwiftUI
import Highcharts

struct StockDetailsView: View {
    
    var stock: StockTicker
    
    @State private var stockSummaryResponse: StockSummaryResponse?
    @State private var stockInsightsResponse: StockInsightsResponse?
    @State private var stockNewsResponse: [NewsArticle]?
    @State private var stockChartsResponse: [StockChartsResponse]?
    @State private var stockHourlyChartsResponse: [StockHourlyChartsResponse]?
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    // Display a loading indicator while data is being fetched
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    // Once data is loaded, display these views
                    ScrollView {
                        StockBasicDetailsView(stock: stock, stockSummaryResponse: self.stockSummaryResponse)
                            .frame(height: 200)
                            .padding([.top, .horizontal])
                        PortfolioView(sharesOwned: 3, averageCost: 171.23)
                    }
                }
            }
            .navigationBarTitle("Stock Details", displayMode: .inline)
        }
        .onAppear {
            fetchSummaryDetails()
            fetchCompanyInsights()
            fetchNewsDetails()
        }
    }
    
    func fetchSummaryDetails() {
        ApiService.shared.fetchStockData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockSummaryResponse = results
                    self.checkIfLoadingShouldStop()
                } else {
                    print("Error fetching stock summary data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func fetchCompanyInsights() {
        ApiService.shared.fetchInsightsData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockInsightsResponse = results
                    self.checkIfLoadingShouldStop()
                } else {
                    print("Error fetching company insights data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func fetchNewsDetails() {
        ApiService.shared.fetchNewsData(symbol: stock.symbol) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockNewsResponse = results
                    self.checkIfLoadingShouldStop()
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
                    self.checkIfLoadingShouldStop()
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
                    self.checkIfLoadingShouldStop()
                } else {
                    print("Error fetching hourly charts data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func checkIfLoadingShouldStop() {
        if stockSummaryResponse != nil && stockInsightsResponse != nil && stockNewsResponse != nil {
            isLoading = false
        }
    }
}

struct StockBasicDetailsView: View {
    var stock: StockTicker
    var stockSummaryResponse: StockSummaryResponse?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(stock.symbol)
                .font(.title)
                .bold()
                .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
            Text(stockSummaryResponse?.stockProfile.name ?? "Loading Name...")
                .font(.title3)
                .foregroundColor(.gray)
            HStack {
                Text(String(format: "$%.2f", stockSummaryResponse?.latestPrice.c ?? 0))
                    .font(.largeTitle)
                    .bold()
                Spacer()
                HStack(spacing: 2) {
                    Text(String(format: "$%.2f", stockSummaryResponse?.latestPrice.dp ?? 0))
                    Text(String(format: "(%.2f%%)", stockSummaryResponse?.latestPrice.pc ?? 0))
                }
                .foregroundColor((stockSummaryResponse?.latestPrice.pc ?? 0) < 0 ? .red : .green)
                .font(.title2)
            }
        }.padding()
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
