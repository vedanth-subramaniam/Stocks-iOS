//
//  FavoritesViewModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteStocks: [StockWishlist] = []
    @Published var favStock: StockWishlist?
    @Published var isStockPresent: Bool = false
    
    func fetchFavoriteStocks() {
        ApiService.shared.fetchFavoriteStocks { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    self?.favoriteStocks = stocks
                }
            } else if let error = error {
                print("Error fetching favorite stocks: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSingleFavouriteStock(ticker: String){
        print("Checking if stock is in favourties")
        ApiService.shared.fetchSingleFavStock(symbol:ticker) { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    self?.favStock = stocks
                    self?.isStockPresent = true
                    print(self?.isStockPresent)
                }
            } else if let error = error {
                print("Error fetching single wishlist data: \(error.localizedDescription)")
                self?.isStockPresent = false
            }
        }
    }
    
    func addToFavourites(ticker: String, companyName: String){
        let wishlistData = StockWishlistDb(ticker: ticker, companyName: companyName)
        ApiService.shared.updateFavStock(wishListRecord: wishlistData) { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    print(stocks)
                }
            } else if let error = error {
                print("Error adding favorite stocks: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFromFavourites(ticker:String){
        ApiService.shared.deleteFavStock(symbol:ticker) { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    print(stocks)
                }
            } else if let error = error {
                print("Error deleting favorite stocks: \(error.localizedDescription)")
            }
        }
    }
    
}
