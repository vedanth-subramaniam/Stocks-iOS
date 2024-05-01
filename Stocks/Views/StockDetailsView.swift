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
    @StateObject var portfolioViewModel = PortfolioViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    ScrollView{
                        Section(){
                            StockBasicDetailsView(stock: stock, stockSummaryResponse: self.stockSummaryResponse)
                                .padding([.top, .horizontal])
                        }
                        
                        Section(){
                            TabView{
                                WebView(htmlFilename: "Charts", ticker: stock.ticker).frame(height:320).tabItem { Label("Hourly", systemImage: "list.dash")}
                                
                                WebView(htmlFilename: "Charts", ticker: stock.ticker).frame(height: 320).tabItem { Label("Historical", systemImage: "list.dash")}
                            }.frame(height: 320)
                        }
                        Section(header: Text("Portfolio").fontWeight(.semibold).font(.title).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding()){
                            PortfolioView(stock:stock)
                        }
                        
                        Section(){
                            StockPriceAndInsightsView(stockSummaryResponse: stockSummaryResponse, stockInsightsResponse: stockInsightsResponse)
                        }
                        Section(header: Text("News").fontWeight(.semibold).font(.title).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding()){
                            ForEach(stockNewsResponse!,  id: \.id) { news in
                                NewsArticleRow(article: news)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchSummaryDetails()
            fetchCompanyInsights()
            fetchNewsDetails()
        }
    }
    
    func fetchSummaryDetails() {
        ApiService.shared.fetchStockData(symbol: stock.ticker) { results, error in
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
        ApiService.shared.fetchInsightsData(symbol: stock.ticker) { results, error in
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
        ApiService.shared.fetchNewsData(symbol: stock.ticker) { results, error in
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
        ApiService.shared.fetchChartsData(symbol: stock.ticker) { results, error in
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
        ApiService.shared.fetchHourlyChartsData(symbol: stock.ticker) { results, error in
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
            Text(stock.ticker)
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
        }
    }
}

#Preview {
    StockDetailsView(stock: StockTicker(ticker: "AAPL"))
}
