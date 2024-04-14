import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            List {
                
                Section(){
                    HStack() {
                        Text("March 21, 2024")
                            .bold()
                    }
                    .listRowBackground(Color.white)
                }
                
                Section(header: Text("PORTFOLIO").bold().font(.subheadline)) {
                    HStack{
                        PortfolioRow(label: "Net Worth", value: "$25009.72")
                        Spacer()
                        PortfolioRow(label: "Cash Balance", value: "$21747.26")
                    }
                    
                    ForEach(portfolioStocks) { stock in
                        StockRow(stock: stock)
                    }
                }
                
                Section(header: Text("FAVORITES").bold().font(.subheadline)) {
                    ForEach(favoriteStocks) { stock in
                        StockRow(stock: stock)
                    }
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
            
        }
    }
}

struct PortfolioRow: View {
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

struct StockRow: View {
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

// Sample data
let portfolioStocks = [
    Stock(symbol: "AAPL", companyName: "3 shares", price: "$514.31", change: "$0.62 (0.12%)", isPositive: true),
    Stock(symbol: "NVDA", companyName: "3 shares", price: "$2748.16", change: "$9.10 (0.33%)", isPositive: true)
]

let favoriteStocks = [
    Stock(symbol: "AAPL", companyName: "Apple Inc", price: "$171.44", change: "-$7.23 (-4.05%)", isPositive: false),
    Stock(symbol: "NVDA", companyName: "NVIDIA Corp", price: "$916.05", change: "$12.33 (1.36%)", isPositive: true)
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


