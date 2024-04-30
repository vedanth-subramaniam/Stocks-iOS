//
//  FavoritesViewModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteStocks: [StockWishlist] = []
    
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
}
