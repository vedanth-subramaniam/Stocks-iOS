import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var searchText: String = ""
    @StateObject var portfolioViewModel = PortfolioViewModel()
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        
        NavigationView {
            List {
                
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
                    ForEach(portfolioViewModel.portfolioStocks) { stock in
                        NavigationLink{
                            StockDetailsHomeRow(stock: stock)
                        } label: {
                            StockDetailsHomeRow(stock: stock)
                        }
                    }
                    .onDelete(perform: deletePortfolioStock(at:))
                    .onMove(perform: movePortfolioStock(from:to:))
                }
                
                Section(header: Text("FAVORITES").bold().font(.subheadline)) {
                    ForEach(favoritesViewModel.favoriteStocks) { stock in
                        NavigationLink{
                            StockDetailsHomeRow(stock: stock)
                        } label: {
                            StockDetailsHomeRow(stock: stock)
                        }
                    }.onDelete(perform: deleteFavoriteStock(at:))
                        .onMove(perform: moveFavoriteStock(from:to:))
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            if let url = URL(string: "https://www.finnhub.io") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Powered by Finnhub.io")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                            
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Stocks", displayMode: .automatic)
            .navigationBarItems(trailing: EditButton())
            .searchable(text: $searchText)
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
        VStack(alignment: .leading){
            Text(label)
                .font(.title2)
            Text(value)
                .bold()
                .font(.title2)
        }
    }
}

struct StockDetailsHomeRow: View {
    var stock: Stock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.headline)
                Text(stock.companyName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(stock.price)
                    .font(.headline)
                HStack(spacing: 4) {
                    Image(systemName: stock.isPositive ? "arrow.up.right" : "arrow.down.right")
                        .foregroundColor(stock.isPositive ? .green : .red)
                    Text(stock.change)
                        .foregroundColor(stock.isPositive ? .green : .red)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
