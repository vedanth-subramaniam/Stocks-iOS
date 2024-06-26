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
                VStack(alignment:.leading, spacing: 10) {
                    HStack {
                        Text("Shares Owned:")
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                        
                        Spacer()
                        Text(String(format: "%.2f", portfolioViewModel.portfolioRecord?.quantity ?? 0))
                    }
                    
                    HStack {
                        Text("Avg. Cost / Share:")
                            .fontWeight(.semibold)
                            .font(.system(size: 13.5))
                            .lineLimit(1)
                        Spacer()
                        Text("$" + String(format: "%.2f", portfolioViewModel.portfolioRecord?.averagePrice ?? 0))
                    }
                    
                    HStack {
                        Text("Total Cost:")
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                        Spacer()
                        Text("$" + String(format: "%.2f", portfolioViewModel.portfolioRecord?.totalCost ?? 0))
                    }
                    
                    HStack {
                        Text("Change:")
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                        
                        Spacer()
                        Text("$" + String(format: "%.2f", portfolioViewModel.portfolioRecord?.changePrice ?? 0))                       .foregroundColor(portfolioViewModel.portfolioRecord?.isPositive ?? true ? .green : .red)

                    }
                    
                    HStack {
                        Text("Market Value:")
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                        Spacer()
                        Text("$" + String(format: "%.2f", portfolioViewModel.portfolioRecord?.marketValue ?? 0))
                            .foregroundColor(portfolioViewModel.portfolioRecord?.isPositive ?? true ? .green : .red)

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
    @StateObject var portfolioViewModel = PortfolioViewModel()
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
            
            Text("\(String(format: "%.2f", portfolioViewModel.stockWalletBalance?.balance ?? 0)) available to buy " + (portfolioViewModel.portfolioRecord?.ticker ?? "AAPL"))
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
            alignment: .bottom
        )
        .sheet(isPresented: $showSuccessModal) {
            SuccessModalView(message: transactionMessage, show: $showSuccessModal)
        }        
        .onReceive(portfolioViewModel.$toastMessage, perform: { newMessage in
            if !newMessage.isEmpty {
                self.toastMessage = newMessage
                self.showingToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showingToast = false
                }
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
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("Congratulations!")
                .font(.system(size: 40))
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                show = false
                print("Done button pressed")
            }) {
                Text("Done")
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 10)
            }.padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    PortfolioView(stock:StockTicker(ticker: "TSLA"))
}
