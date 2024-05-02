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
        VStack(spacing: 20){
            Section(header: Text("Stats").frame(maxWidth:.infinity,alignment: .leading).font(.title2)) {
                VStack(spacing: 10){
                    HStack(){
                        Text("High Price").bold()
                        Text(String(format: "$%.2f", latestPrice?.h ?? 0))
                        Spacer()
                        Text("Open Price").bold()
                        Text(String(format: "$%.2f", latestPrice?.o ?? 0))
                    }
                    HStack(){
                        Text("Low Price").bold()
                        Text(String(format: "$%.2f", latestPrice?.h ?? 0))
                        Spacer()
                        Text("Prev. Close").bold()
                        Text(String(format: "$%.2f", latestPrice?.o ?? 0))
                    }
                }.font(.system(size: 18))
                
            }
            Section(header: Text("About").frame(maxWidth: .infinity, alignment: .leading).font(.title2)) {
                if let profile = stockProfile {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("IPO Start Date:").frame(width: 200, alignment: .leading)
                            Text(profile.ipo ?? "")
                                .foregroundColor(.gray).frame(alignment: .leading).bold()
                        }
                        
                        HStack {
                            Text("Industry:").frame(width: 200, alignment: .leading)
                            Text(profile.finnhubIndustry ?? "")
                                .foregroundColor(.gray).frame(alignment: .leading).bold()
                        }
                        
                        HStack {
                            Text("Webpage:").frame(width: 200, alignment: .leading)
                            Link(destination: profile.weburl) {
                                Text(profile.weburl.absoluteString)
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue).frame(alignment: .leading).lineLimit(1)
                            }
                        }
                        
                        HStack {
                            Text("Company Peers:").frame(width: 200, alignment: .leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 10) {
                                    ForEach(stockSummaryResponse?.companyPeers ?? [], id: \.self) { peer in
                                        NavigationLink(destination: StockDetailsView(stock: StockTicker(ticker: peer))) {
                                            Text(peer + ", ")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 12))
                                        }
                                    }.frame(alignment: .leading)
                                }
                            }
                        }
                    }
                }
            }
            Section(header: Text("Insights").frame(maxWidth:.infinity,alignment: .leading).font(.title2)){
                VStack(alignment: .center, spacing: 8) {
                    Text("Insider Sentiments").font(.title2)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stockProfile?.name ?? "No Value").frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                            Text("MSPR").font(.headline).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Divider()
                            Text(String(format: "%.2f", self.averageMspr))
                                .font(.system(size: 15))

                            Divider()
                            Text(String(format: "%.2f", self.averagePositiveMspr))
                                .font(.system(size: 15))

                            Divider()
                            Text(String(format: "%.2f", self.averageNegativeMspr))
                                .font(.system(size: 15))

                            Divider()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Change").font(.headline).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Divider()
                            Text(String(format: "%.2f", self.averageChange))
                                .font(.system(size: 15))

                            Divider()
                            Text(String(format: "%.2f", self.averagePositiveChange))
                                .font(.system(size: 15))

                            Divider()
                            Text(String(format: "%.2f", self.averageNegativeChange))
                                .font(.system(size: 15))

                            Divider()
                        }
                        Spacer()
                    }
                }
                ChartsWebView(htmlFilename: "RecommendationChart", ticker: stockProfile?.ticker ?? "AAPL").frame(height:200)
                ChartsWebView(htmlFilename: "SurpriseChart", ticker: stockProfile?.ticker ?? "AAPL").frame(height:320)
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
        
        var totalChange: Double = 0
        var totalPositiveChange: Double = 0
        var totalNegativeChange: Double = 0
        
        for sentiment in data {
            totalMspr += sentiment.mspr
            if sentiment.mspr > 0 {
                totalPositiveMspr += sentiment.mspr
            } else {
                totalNegativeMspr += sentiment.mspr
            }
            
            totalChange += Double(sentiment.change)
            if sentiment.change > 0 {
                totalPositiveChange += Double(sentiment.change)
            } else {
                totalNegativeChange += Double(sentiment.change)
            }
        }
        
        // Compute averages
        averageMspr = totalMspr
        averagePositiveMspr =  totalPositiveMspr
        averageNegativeMspr = totalNegativeMspr
        averageChange = totalChange
        averagePositiveChange = totalPositiveChange
        averageNegativeChange = totalNegativeChange
        
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
