import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var searchThrottleTimer: Timer?
    @State private var autocompleteResults: [StockAutocomplete] = []
    @State var walletBalance: Int?
    
    @StateObject var portfolioViewModel = PortfolioViewModel()
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if searchText.isEmpty {
                    
                    Section(){
                        HStack() {
                            Text(currentDateString())
                                .fontWeight(.ultraLight)
                                .font(.title2)
                        }
                        .listRowBackground(Color.white)
                    }
                    
                    Section(header: Text("PORTFOLIO").bold().font(.subheadline)) {
                        HStack{
                            PortfolioAccountRow(label: "Net Worth", value: "$25009.72")
                            Spacer()
                            PortfolioAccountRow(label: "Cash Balance", value: "$21747.26")
                        }
                        ForEach(portfolioViewModel.portfolioStocks,  id: \.ticker) { stock in
                            NavigationLink(destination: StockDetailsView(stock: StockTicker(ticker: stock.ticker))) {
                                StockDetailsPortfolioRow(stock: stock)
                            }
                        }
                        .onDelete(perform: deletePortfolioStock)
                        .onMove(perform: movePortfolioStock)
                    }
                    
                    Section(header: Text("FAVORITES").bold().font(.subheadline)) {
                        ForEach(favoritesViewModel.favoriteStocks,  id: \.ticker) { stock in
                            NavigationLink(destination: StockDetailsView(stock: StockTicker(ticker: stock.ticker))) {
                                StockDetailsWishlistRow(stock: stock)
                            }
                        }
                        .onDelete(perform: deleteFavoriteStock)
                        .onMove(perform: moveFavoriteStock)
                    }
                } else {
                    ForEach(autocompleteResults, id: \.ticker) { result in
                        HStack {
                            NavigationLink(destination: StockDetailsView(stock: StockTicker(ticker: result.displaySymbol))){
                                VStack(alignment: .leading) {
                                    Text(result.ticker)
                                        .font(.headline)
                                    Text(result.description)
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(searchText.isEmpty ? "Stocks" : "")
            .navigationBarItems(trailing: searchText.isEmpty ? EditButton() : nil)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    autocompleteResults = []
                } else {
                    searchThrottleTimer?.invalidate()
                    searchThrottleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        performSearch(query: newValue)
                    }
                }
            }
            .onAppear(){
                portfolioViewModel.fetchPortfolioData()
                favoritesViewModel.fetchFavoriteStocks()
            }
        }
    }
    
    
    func deletePortfolioStock(at offsets: IndexSet) {
        portfolioViewModel.portfolioStocks.remove(atOffsets: offsets)
    }
    
    func movePortfolioStock(from source: IndexSet, to destination: Int) {
        portfolioViewModel.portfolioStocks.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteFavoriteStock(at offsets: IndexSet) {
        favoritesViewModel.favoriteStocks.remove(atOffsets: offsets)
    }
    
    func moveFavoriteStock(from source: IndexSet, to destination: Int) {
        favoritesViewModel.favoriteStocks.move(fromOffsets: source, toOffset: destination)
    }
    
    func performSearch(query: String) {
        ApiService.shared.fetchAutocompleteData(query: query) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.autocompleteResults = results
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    self.autocompleteResults = []
                }
            }
        }
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}


struct PortfolioAccountRow: View {
    var label: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.title2)
            Text(value)
                .bold()
                .font(.title2)
        }
    }
}

struct StockDetailsPortfolioRow: View {
    var stock: StockPortfolio
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.ticker)
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(String(format: "%.0f", stock.quantity) + " Shares")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", stock.price * stock.quantity))
                    .font(.title2)
                HStack(spacing: 4) {
                    Image(systemName: stock.isPositive ? "arrow.up.right" : "arrow.down.right")
                        .foregroundColor(stock.isPositive ? .green : .red)
                    Text(String(format: "%.2f", stock.changePrice))
                        .foregroundColor(stock.isPositive ? .green : .red)
                    Text("(" + stock.changePricePercent + ")")
                        .foregroundColor(stock.isPositive ? .green : .red)
                }
            }
        }.font(.title3)
    }
}

struct StockDetailsWishlistRow: View {
    var stock: StockWishlist
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.ticker)
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(stock.companyName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", stock.price))
                    .font(.title2)
                HStack(spacing: 4) {
                    Image(systemName: stock.isPositive ? "arrow.up.right" : "arrow.down.right")
                        .foregroundColor(stock.isPositive ? .green : .red)
                    Text(String(format: "%.2f", stock.changePrice))
                        .foregroundColor(stock.isPositive ? .green : .red)
                    Text("(" + stock.changePricePercent + ")")
                        .foregroundColor(stock.isPositive ? .green : .red)
                }
            }
        }.font(.title3)
    }
}

#Preview {
    ContentView()
}
