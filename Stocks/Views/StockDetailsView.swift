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
    @State private var isFavToggled: Bool = false
    @StateObject var favouriteModel = FavoritesViewModel()
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching stock details...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                ScrollView{
                    Section(){
                        StockBasicDetailsView(stock: stock, stockSummaryResponse: self.stockSummaryResponse)
                            
                    }.padding()
                    
                    Section(){
                        TabView{
                            HourlyChartsWebView(htmlFilename: "HourlyCharts", ticker: stock.ticker, color: "false").frame(width: 390).frame(height:420).tabItem { Label("Hourly", systemImage: "chart.line.uptrend.xyaxis")}
                            
                            ChartsWebView(htmlFilename: "Charts", ticker: stock.ticker).frame(width: 400).frame(height: 390).tabItem { Label("Historical", systemImage: "clock")}
                        }.frame(height: 450)
                    }
                    Section(header: Text("Portfolio").fontWeight(.semibold).font(.title).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding()){
                        PortfolioView(stock:stock)
                    }.padding(.horizontal)
                    
                    Section(){
                        StockPriceAndInsightsView(stockSummaryResponse: stockSummaryResponse, stockInsightsResponse: stockInsightsResponse)
                    }.padding(.horizontal)
                    Section() {
                        VStack(){
                            Text("News")
                                .fontWeight(.semibold)
                                .font(.title)
                                .padding(.horizontal, 30)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if let news = stockNewsResponse, !news.isEmpty {
                                FirstNewsArticleRow(article: news.first!)
                                    .padding()
                                ForEach(Array(news.dropFirst().enumerated()), id: \.element.id) { index, article in
                                    NewsArticleRow(article: article).padding()
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            
        }.navigationBarTitle(stock.ticker, displayMode: .inline)
            .navigationBarItems(trailing: toggleButton)
            .onAppear {
                fetchSummaryDetails()
                fetchCompanyInsights()
                fetchNewsDetails()
                favouriteModel.fetchSingleFavouriteStock(ticker: stock.ticker)
            }
            .onReceive(favouriteModel.$isStockPresent){ isPresent in
                isFavToggled = isPresent
                print(isFavToggled)
            }.overlay(
                ToastView(message: toastMessage, isShowing: $showingToast)
                    .animation(.easeInOut, value: showingToast)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom),
                alignment: .bottom  // Align the overlay itself to the bottom
            )
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
    
    private var toggleButton: some View {
        Button(action: {
            // Toggle the isToggled state when button is tapped
            isFavToggled.toggle()
            handleToggleChange()
        }) {
            Image(systemName: "plus")
                .foregroundColor(isFavToggled ? .white : .blue)
                .font(.system(size: 10, weight: .bold))
                .padding(7)
                .background(Circle().fill(isFavToggled ? .blue : .white))
                .overlay(Circle().stroke(isFavToggled ? .white : .blue, lineWidth: 2))
        }
    }
    
    private func handleToggleChange() {
        if isFavToggled {
            print("adding to fav")
            self.toastMessage = "Added " + stock.ticker + " to favorites"
            self.showingToast = true
            favouriteModel.addToFavourites(ticker: stock.ticker, companyName: stockSummaryResponse?.stockProfile.name ?? "")
        } else {
            print("removing from fav")
            self.toastMessage = "Removed " + stock.ticker + " from favorites"
            self.showingToast = true
            favouriteModel.removeFromFavourites(ticker: stock.ticker)
        }
    }
}

struct StockBasicDetailsView: View {
    var stock: StockTicker
    var stockSummaryResponse: StockSummaryResponse?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(stock.ticker)
                .font(.title)
                .bold()
            Text(stockSummaryResponse?.stockProfile.name ?? "Loading Name...")
                .font(.title3)
                .foregroundColor(.gray)
            HStack {
                Text(String(format: "$%.2f", stockSummaryResponse?.latestPrice.c ?? 0))
                    .font(.largeTitle)
                    .bold()
                Spacer()
                HStack(spacing: 2) {
                    Text(String(format: "$%.2f", stockSummaryResponse?.latestPrice.d ?? 0))
                    Text(String(format: "(%.2f%%)", stockSummaryResponse?.latestPrice.dp ?? 0))
                }
                .foregroundColor((stockSummaryResponse?.latestPrice.dp ?? 0) < 0 ? .red : .green)
                .font(.title2)
            }
        }.padding()
    }
}

#Preview {
    StockDetailsView(stock: StockTicker(ticker: "AAPL"))
}
