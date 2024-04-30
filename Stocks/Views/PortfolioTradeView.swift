//
//  PortfolioTradeView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/30/24.
//

import SwiftUI

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
            
            Text("Trade")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            HStack(){
                TextField("0",text: $numberOfShares)
                    .font(.system(size: 100))
                    .fontWeight(.light)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                VStack(alignment:.trailing){
                    Text("Shares")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(" × " +
                        String(format: "$%.2f", portfolioViewModel.portfolioRecord?.price ?? 0) +
                        "/share = " +
                        String(format: "$%.2f", (portfolioViewModel.portfolioRecord?.price ?? 0) * (Double(numberOfShares) ?? 0))
                    )
                    .font(.callout)
                    .foregroundColor(.gray)
                    .frame(width: 250, height: 50, alignment: .trailing)
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

//#Preview {
//    PortfolioView(stock:StockTicker(ticker: "AAPL"))
//}
