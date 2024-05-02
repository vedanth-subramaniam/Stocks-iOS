//
//  PortfolioViewModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    @Published var portfolioStocks: [StockPortfolio] = []
    @Published var portfolioRecord: StockPortfolio?
    @Published var stockWalletBalance: StockWalletBalance?
    @Published var toastMessage = ""
    @Published var transactionMessage = ""
    @Published var isLoadingHomePage: Bool = false
    @Published var netWorth: Double = 25000

    
    func fetchPortfolioData() {
        self.isLoadingHomePage = true
        print("Fetching portfolio")
        ApiService.shared.fetchPortfolioData { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    self?.portfolioStocks = stocks
                    self?.calculateNetWorth()
                    self?.isLoadingHomePage = false
                }
            } else if let error = error {
                print("Error fetching portfolio data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPortfolioRecord(ticker: String) {
        print("Calling Single portfolio record")
        print(ticker)
        ApiService.shared.fetchSinglePortfolioRecord(symbol:ticker) { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    self?.portfolioRecord = stocks
                }
            } else if let error = error {
                print("Error fetching single portfolio data: \(error.localizedDescription)")
                ApiService.shared.fetchLatestPrice(symbol:ticker) { [weak self] price, error in
                    if let price = price {
                        DispatchQueue.main.async {
                            print("Latest price is here!")
                            self?.portfolioRecord?.price = price.c ?? 0
                            self?.portfolioRecord?.changePrice = 0
                            self?.portfolioRecord?.changePricePercent = "0%"
                            self?.portfolioRecord = StockPortfolio(ticker: ticker, quantity: 0, totalCost: 0, averagePrice: 0, price: price.c ?? 0, marketValue: 0, changePrice: 0, changePricePercent: "0%", isPositive: false)
                            print("Created new record") 
                            print(self?.portfolioRecord)
                        }
                    } else if let error = error {
                        print("Error fetching latestPrice data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func fetchWalletBalance() {
        ApiService.shared.fetchWalletBalance() { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.stockWalletBalance = results
                } else {
                    print("Error fetching wallet balance: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func updateWalletBalance(){
        var walletBalance = StockWalletBalance(balance: stockWalletBalance?.balance ?? 0)
        ApiService.shared.updateWalletBalance(wallet: walletBalance) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    print("printing results")
                    print(results)
                } else {
                    print("Error fetching wallet balance: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

    }
    
    func updatePortfolioRecord(portfolioRecord: StockPortfolioDb) {
        print("Adding/Updating Portfolio DB")
        ApiService.shared.updatePortfolioRecord(portfolioRecord: portfolioRecord) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    print(results)
                } else {
                    print("Error fetching wallet balance: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

    }
    
    func buyShares(count: Double) {
        guard count > 0 else {
            showToast(message: "Cannot buy non-positive shares")
            return
        }
        guard let pricePerShare = portfolioRecord?.price, let balance = stockWalletBalance?.balance else {
            showToast(message: "Please enter a valid amount")
            return
        }
        let totalCost = pricePerShare * count
        if totalCost <= balance {
            stockWalletBalance?.balance -= totalCost
            portfolioRecord?.quantity += count
            portfolioRecord?.totalCost += totalCost
            print("Updated wallet balance")
            updateWalletBalance()
            print(stockWalletBalance)
            print("Updated portfolio Record")
            updatePortfolioRecord(portfolioRecord: StockPortfolioDb(ticker: portfolioRecord?.ticker ?? "", quantity: portfolioRecord?.quantity ?? 0, totalCost: portfolioRecord?.totalCost ?? 0))
            print(portfolioRecord)
            transactionMessage = "You have successfully bought " + String(format:"%.0f", count) + " shares of " + (portfolioRecord?.ticker ?? "AAPL")
        } else {
            showToast(message: "Not enough money to buy")
        }
    }
    
    func sellShares(count: Double) {
        guard count > 0 else {
            showToast(message: "Cannot sell non-positive shares")
            return
        }
        guard let quantity = portfolioRecord?.quantity else {
            showToast(message: "Please enter a valid amount")
            return
        }
        if count <= quantity {
            portfolioRecord?.quantity -= count
            if let pricePerShare = portfolioRecord?.price {
                stockWalletBalance?.balance += pricePerShare * count
            }
            let totalCost = (portfolioRecord?.price ?? 0) * count
            portfolioRecord?.totalCost -= totalCost
            print("Updated wallet balance")
            print(stockWalletBalance)
            print("Updated portfolio Record")
            print(portfolioRecord)
            updatePortfolioRecord(portfolioRecord: StockPortfolioDb(ticker: portfolioRecord?.ticker ?? "", quantity: portfolioRecord?.quantity ?? 0, totalCost: portfolioRecord?.totalCost ?? 0))
            updateWalletBalance()
            transactionMessage = "You have successfully sold " + String(format:"%.0f", count) + " shares of " + (portfolioRecord?.ticker ?? "AAPL")
        } else {
            showToast(message: "Not enough shares to sell")
        }
    }
    
    private func showToast(message: String) {
        DispatchQueue.main.async {
            self.toastMessage = message
        }
    }
    
    private func calculateNetWorth() {
        let stocksValue = portfolioStocks.reduce(0) { $0 + $1.marketValue }
        netWorth = stockWalletBalance?.balance ?? 25000 + stocksValue
    }

}
