//
//  PortfolioViewModel.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    @Published var portfolioStocks: [Stock] = []
    
    func fetchPortfolioData() {
        ApiService.shared.fetchPortfolioData { [weak self] stocks, error in
            if let stocks = stocks {
                DispatchQueue.main.async {
                    self?.portfolioStocks = stocks
                }
            } else if let error = error {
                print("Error fetching portfolio data: \(error.localizedDescription)")
            }
        }
    }
}
