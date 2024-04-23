//
//  StockDetailsView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/20/24.
//

import SwiftUI

struct StockDetailsView: View {
    // Dummy data for demonstration purposes
    var stock: StockName
    let stockPrice: Double = 171.09
    let priceChange: Double = -7.58
    let percentageChange: Double = -4.24
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stock.symbol)
                                .font(.largeTitle)
                                .bold()
                            Text(stock.companyName)
                                .font(.caption)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(String(format: "$%.2f", priceChange))
                                .font(.largeTitle)
                                .bold()
                            HStack(spacing: 2) {
                                Text(String(format: "$%.2f", priceChange))
                                Text(String(format: "(%.2f%%)", percentageChange))
                            }
                            .foregroundColor(priceChange < 0 ? .red : .green)
                        }
                    }
                    .padding()
                    
                    // Placeholder for the chart view
                    ChartPlaceholderView()
                        .frame(height: 200)
                        .padding([.top, .horizontal])
                    
                    // Portfolio Section
                    PortfolioView(sharesOwned: 3, averageCost: 171.23)
                }
            }
            .navigationBarTitle("Stocks", displayMode: .inline)
        }
    }
}

struct ChartPlaceholderView: View {
    var body: some View {
        // This would be replaced by the actual charting code
        // You would use a UIViewRepresentable to wrap your Highcharts view
        Text("Chart View Placeholder")
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

struct PortfolioView: View {
    let sharesOwned: Int
    let averageCost: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Portfolio")
                .font(.headline)
                .padding(.vertical, 4)
            HStack {
                VStack(alignment: .leading) {
                    Text("Shares Owned:")
                    Text("Avg. Cost / Share:")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(sharesOwned)")
                    Text(String(format: "$%.2f", averageCost))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            // Dummy progress bar
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .frame(height: 6)
                .padding(.horizontal)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    StockDetailsView(stock: StockName(symbol: "AAPL", companyName: "Apple Inc"))
}
