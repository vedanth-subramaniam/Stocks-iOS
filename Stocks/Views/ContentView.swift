import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var portfolioStocks = [
        Stock(symbol: "AAPL", companyName: "3 shares", price: "$514.31", change: "$0.62 (0.12%)", isPositive: true),
        Stock(symbol: "NVDA", companyName: "3 shares", price: "$2748.16", change: "$9.10 (0.33%)", isPositive: true)
    ]

    @State private var favoriteStocks = [
        Stock(symbol: "AAPL", companyName: "Apple Inc", price: "$171.44", change: "-$7.23 (-4.05%)", isPositive: false),
        Stock(symbol: "NVDA", companyName: "NVIDIA Corp", price: "$916.05", change: "$12.33 (1.36%)", isPositive: true)
    ]
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
                    
                    ForEach(portfolioStocks) { stock in
                        StockDetailsHomeRow(stock: stock)
                    }
                    .onDelete(perform: deletePortfolioStock(at:))
                    .onMove(perform: movePortfolioStock(from:to:))
                }
                
                Section(header: Text("FAVORITES").bold().font(.subheadline)) {
                    ForEach(favoriteStocks) { stock in
                        StockDetailsHomeRow(stock: stock)
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
        }
    }
    
    func deletePortfolioStock(at offsets: IndexSet) {
        portfolioStocks.remove(atOffsets: offsets)
    }
    
    func movePortfolioStock(from source: IndexSet, to destination: Int) {
        portfolioStocks.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteFavoriteStock(at offsets: IndexSet) {
        favoriteStocks.remove(atOffsets: offsets)
    }
    
    func moveFavoriteStock(from source: IndexSet, to destination: Int) {
        favoriteStocks.move(fromOffsets: source, toOffset: destination)
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

struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let companyName: String
    let price: String
    let change: String
    let isPositive: Bool
}

#Preview {
    ContentView()
}
