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
    
    func fetchPortfolioData() {
        ApiService.shared.fetchPortfolioData { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    self?.portfolioStocks = stocks
                    print(self?.portfolioStocks)
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
            }
        }
    }
    
    func addPortfolioRecord(portfolioRecord: StockPortfolioDb) {
        print("Adding the following record into Portfolio DB")
        print(portfolioRecord)
    }
    
    func addWishListRecord(wishListRecord: StockWishlistDb){
        print("Adding the following record into Wishlist DB")
        print(wishListRecord)
    }
}
