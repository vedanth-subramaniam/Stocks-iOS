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
                        StockBasicDetailsView(stock: stock, stockSummaryResponse: self.stockSummaryResponse)
                            .padding([.top, .horizontal])
                        WebView(htmlFilename: "Charts", ticker: stock.ticker).onAppear {
                            print("WebView is appearing with ticker: \(stock.ticker)")
                        }.frame(height: 320)
                        Text("Portfolio")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        PortfolioView(stock:stock)
                        Section(header: Text("News").bold().font(.title).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)) {
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

struct PortfolioView: View {
    var stock:StockTicker
    @State private var showingTradeSheet = false
    @StateObject var portfolioViewModel = PortfolioViewModel()
    
    var body: some View {
        HStack() {
            VStack(alignment:.leading) {
                HStack {
                    Text("Shares Owned:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", portfolioViewModel.portfolioRecord?.quantity ?? 0))
                }
                
                HStack {
                    Text("Avg. Cost / Share:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", portfolioViewModel.portfolioRecord?.averagePrice ?? 0))
                }
                
                HStack {
                    Text("Total Cost:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", portfolioViewModel.portfolioRecord?.totalCost ?? 0))
                }
                
                HStack {
                    Text("Change:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", portfolioViewModel.portfolioRecord?.changePrice ?? 0))                                        }
                
                HStack {
                    Text("Market Value:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(format: "%.2f", portfolioViewModel.portfolioRecord?.marketValue ?? 0))                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button(action: {showingTradeSheet.toggle()}) {
                Text("Trade")
                    .foregroundColor(.white)
                    .frame(maxWidth: 100)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(20)
            }.padding()
                .sheet(isPresented: $showingTradeSheet){
                    TradeSheetView(portfolioViewModel: portfolioViewModel)
                }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .onAppear(){
            portfolioViewModel.fetchPortfolioRecord(ticker: stock.ticker)
        }
    }
}

struct TradeSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var portfolioViewModel = PortfolioViewModel()
    @State var numberOfShares: String  = "0"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                }
                .padding()
            }
            
            Text("Trade Apple Inc shares")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            HStack(){
                TextField("0",text: $numberOfShares)
                    .font(.system(size: 100))
                    .fontWeight(.light)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                
                VStack(alignment:.trailing){
                    Text("Shares")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("× $171.09/share = $342.18")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .fontWeight(.none)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
            }.padding()
            
            Spacer()
            
            Text("$22260.53 available to buy AAPL")
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            HStack(spacing: 20) {
                Button("Buy") {
                    // Handle buy action
                }
                .buttonStyle(GreenButtonStyle())
                
                Button("Sell") {
                    // Handle sell action
                }
                .buttonStyle(GreenButtonStyle())
            }
            .padding()
        }
    }
}

struct GreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}


struct NewsArticleRow: View {
    var article: NewsArticle
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: article.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(article.headline)
                    .font(.headline)
                    .lineLimit(3)
                Text(article.formattedDateTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    StockDetailsView(stock: StockTicker(ticker: "AAPL"))
}
