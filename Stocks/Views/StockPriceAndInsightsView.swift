//
//  StockPriceAndInsightsView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/30/24.
//

import SwiftUI
import Highcharts

struct ChartView: UIViewRepresentable {
    
    var options: HIOptions
    
    func makeUIView(context: Context) -> HIChartView {
        let chart = HIChartView()
        chart.options = options
        return chart
    }
    
    func updateUIView(_ uiView: HIChartView, context: Context) {
        uiView.options = options
    }
}

struct StockPriceAndInsightsView: View {
    
    var stockSummaryResponse: StockSummaryResponse?
    var stockInsightsResponse: StockInsightsResponse?
    @State private var stockRecommendations:[StockRecommendation]?
    @State private var insiderSentiments: InsiderSentiments?
    @State private var companyEarnings: [CompanyEarning]?
    @State private var latestPrice: LatestPrice?
    @State private var stockProfile: StockProfile?
    @State private var averageMspr:Double = 0;
    @State private var averagePositiveMspr:Double = 0;
    @State private var averageNegativeMspr:Double = 0;
    @State private var averageChange:Double = 0;
    @State private var averagePositiveChange:Double = 0;
    @State private var averageNegativeChange:Double = 0;
    
    var body: some View {
        VStack(){
            Section(header: Text("Stats").frame(maxWidth:.infinity,alignment: .leading).font(.title2)) {
                HStack(){
                    Text("High Price")
                    Text(String(format: "$%.2f", latestPrice?.h ?? 0))
                    Spacer()
                    Text("Open Price")
                    Text(String(format: "$%.2f", latestPrice?.o ?? 0))
                }
                HStack(){
                    Text("Low Price")
                    Text(String(format: "$%.2f", latestPrice?.h ?? 0))
                    Spacer()
                    Text("Prev. Close")
                    Text(String(format: "$%.2f", latestPrice?.o ?? 0))
                }
                Spacer()
            }
            Spacer()
            Section(header: Text("About").frame(maxWidth: .infinity, alignment: .leading).font(.title2)) {
                if let profile = stockProfile {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("IPO Start Date:")
                            Spacer()
                            Text(profile.ipo ?? "")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Industry:")
                            Spacer()
                            Text(profile.finnhubIndustry ?? "")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Webpage:")
                            Spacer()
                            Link(destination: profile.weburl) {
                                Text(profile.weburl.absoluteString)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        HStack {
                            Text("Company Peers:")
                            Spacer()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 10) {
                                    ForEach(stockSummaryResponse?.companyPeers ?? [], id: \.self) { peer in
                                        NavigationLink(destination: StockDetailsView(stock: StockTicker(ticker: peer))) {
                                            Text(peer)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    Text("No company profile available.")
                }
                Spacer()
            }
            Spacer()
            Section(header: Text("Insights").frame(maxWidth:.infinity,alignment: .leading).font(.title2)){
                VStack(alignment: .center, spacing: 8) {
                    Text("Insider Sentiments").font(.title2)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stockProfile?.name ?? "No Value")
                            Divider()
                            Text("Total").font(.headline)
                            Divider()
                            Text("Positive").font(.headline)
                            Divider()
                            Text("Negative").font(.headline)
                            Divider()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("MSPR").font(.headline)
                            Divider()
                            Text(String(format: "%.2f", self.averageMspr))
                            Divider()
                            Text(String(format: "%.2f", self.averagePositiveMspr))
                            Divider()
                            Text(String(format: "%.2f", self.averageNegativeMspr))
                            Divider()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Change").font(.headline)
                            Divider()
                            Text(String(format: "%.2f", self.averageChange))
                            Divider()
                            Text(String(format: "%.2f", self.averagePositiveChange))
                            Divider()
                            Text(String(format: "%.2f", self.averageNegativeChange))
                            Divider()
                        }
                        Spacer()
                    }.padding()
                }

            }
        }
        .padding()
        .font(.headline)
        .onAppear {
            stockProfile = stockSummaryResponse?.stockProfile
            latestPrice = stockSummaryResponse?.latestPrice
            companyEarnings = stockInsightsResponse?.companyEarnings
            insiderSentiments = stockInsightsResponse?.insiderSentiments
            stockRecommendations = stockInsightsResponse?.stockRecommendations
            computeAverages(from: insiderSentiments?.data)
            
        }
    }
    
    func computeAverages(from data: [InsiderSentimentData]?) {
        guard let data = data, !data.isEmpty else {
            print("No data available to compute averages.")
            return
        }
        // Initialize sums and counts
        var totalMspr: Double = 0
        var totalPositiveMspr: Double = 0
        var totalNegativeMspr: Double = 0
        var countPositiveMspr = 0
        var countNegativeMspr = 0
        
        var totalChange: Double = 0
        var totalPositiveChange: Double = 0
        var totalNegativeChange: Double = 0
        var countPositiveChange = 0
        var countNegativeChange = 0
        
        for sentiment in data {
            // Sum MSPRs
            totalMspr += sentiment.mspr
            if sentiment.mspr > 0 {
                totalPositiveMspr += sentiment.mspr
                countPositiveMspr += 1
            } else {
                totalNegativeMspr += sentiment.mspr
                countNegativeMspr += 1
            }
            
            // Sum Changes
            totalChange += Double(sentiment.change)
            if sentiment.change > 0 {
                totalPositiveChange += Double(sentiment.change)
                countPositiveChange += 1
            } else {
                totalNegativeChange += Double(sentiment.change)
                countNegativeChange += 1
            }
        }
        
        // Compute averages
        averageMspr = totalMspr / Double(data.count)
        averagePositiveMspr = countPositiveMspr > 0 ? totalPositiveMspr / Double(countPositiveMspr) : 0
        averageNegativeMspr = countNegativeMspr > 0 ? totalNegativeMspr / Double(countNegativeMspr) : 0
        averageChange = totalChange / Double(data.count)
        averagePositiveChange = countPositiveChange > 0 ? totalPositiveChange / Double(countPositiveChange) : 0
        averageNegativeChange = countNegativeChange > 0 ? totalNegativeChange / Double(countNegativeChange) : 0
        
        // Print results
        print("Average MSPR: \(averageMspr)")
        print("Average Positive MSPR: \(averagePositiveMspr)")
        print("Average Negative MSPR: \(averageNegativeMspr)")
        print("Average Change: \(averageChange)")
        print("Average Positive Change: \(averagePositiveChange)")
        print("Average Negative Change: \(averageNegativeChange)")
    }
}
//
#Preview {
    StockPriceAndInsightsView()
}
