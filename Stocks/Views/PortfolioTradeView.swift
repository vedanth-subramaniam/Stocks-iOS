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
            if let quantity = portfolioViewModel.portfolioRecord?.quantity, quantity > 0{
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
            } else {
                VStack(alignment: .leading){
                    Text("You have 0 shares of " + (portfolioViewModel.portfolioRecord?.ticker ?? "")).frame(width: 200, alignment: .leading)
                    Text("Start Trading!")
                }.font(.subheadline)
            }
            
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
            portfolioViewModel.fetchWalletBalance()
        }
    }
}

struct TradeSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var portfolioViewModel = PortfolioViewModel()  // Changed to StateObject to ensure it persists correctly
    @State var numberOfShares: String = "0"
    @State private var showingToast = false
    @State private var toastMessage = ""
    @State private var showSuccessModal = false
    @State private var transactionMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    portfolioViewModel.fetchPortfolioRecord(ticker: portfolioViewModel.portfolioRecord?.ticker ?? "")
                }) {
                    Image(systemName: "xmark")
                }
                .padding()
            }
            
            Text("Trade")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            HStack {
                TextField("0", text: $numberOfShares)
                    .font(.system(size: 100))
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing) {
                    Text("Shares")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(" × \(String(format: "$%.2f", portfolioViewModel.portfolioRecord?.price ?? 0))/share = \(String(format: "$%.2f", (portfolioViewModel.portfolioRecord?.price ?? 0) * (Double(numberOfShares) ?? 0)))")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .frame(width: 250, height: 50, alignment: .trailing)
                }
            }.padding()
            
            Spacer()
            
            Text("\(String(format: "%.2f", portfolioViewModel.stockWalletBalance?.balance ?? 0)) available to buy AAPL")
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            HStack(spacing: 20) {
                Button("Buy") {
                    portfolioViewModel.buyShares(count: Double(numberOfShares) ?? 0)
                }
                .buttonStyle(GreenButtonStyle())
                
                Button("Sell") {
                    portfolioViewModel.sellShares(count: Double(numberOfShares) ?? 0)
                }
                .buttonStyle(GreenButtonStyle())
            }
            .padding()
        }.overlay(
            ToastView(message: toastMessage, isShowing: $showingToast)
                .animation(.easeInOut, value: showingToast)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom),
            alignment: .bottom  // Align the overlay itself to the bottom
        )
        .sheet(isPresented: $showSuccessModal) {
            // This is the custom modal view, adjust as necessary
            SuccessModalView(message: transactionMessage, show: $showSuccessModal)
        }        .onReceive(portfolioViewModel.$toastMessage, perform: { newMessage in
            if !newMessage.isEmpty {
                self.toastMessage = newMessage
                self.showingToast = true
            }
        })
        .onReceive(portfolioViewModel.$transactionMessage, perform: { newMessage in
            self.transactionMessage = newMessage
            self.showSuccessModal = true
        }).onAppear(){
            self.transactionMessage = ""
            self.showingToast = false
            self.toastMessage = ""
            self.showSuccessModal = false
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

struct SuccessModalView: View {
    var message: String
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .font(.headline)
                .fontWeight(.bold)
            Button("Done") {
                show = false // This will dismiss the modal
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    PortfolioView(stock:StockTicker(ticker: "GOOGL"))
}
