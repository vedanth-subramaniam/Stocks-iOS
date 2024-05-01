//
//  NewsView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/30/24.
//

import SwiftUI

struct NewsArticleRow: View {
    var article: NewsArticle
    @State private var showingNewsDetailsSheet = false
    var body: some View {
        Button(action: {
            showingNewsDetailsSheet.toggle()
        }){ HStack {
            AsyncImage(url: URL(string: article.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(article.headline)
                    .font(.headline)
                    .lineLimit(3)
                Text(article.formattedDateTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }.sheet(isPresented: $showingNewsDetailsSheet) {
            NewsDetailView(news: article)
        }
        }.onAppear(){
            print(article)
        }
    }
}


struct NewsDetailView: View {
    let news: NewsArticle // Assuming you have a data model named NewsDataItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(" \(news.source)")
                    Text(" \(formattedDate(news.datetime))")
                        .foregroundColor(.gray)
                }.foregroundColor(.primary)
                Divider()
                Text(news.headline)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .font(.title2)
                    .bold()
                
                Text(news.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("For more details,click ")
                    Link(destination: URL(string: news.url)!) {
                        Text("here")
                            .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    Image("TwitterIcon") // Use the name of your image set
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            shareOnTwitter(newsTitle: news.headline, newsURL: news.url)
                        }
                    
                    Image("FacebookIcon") // Use the name of your image set
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            shareOnFacebook(newsTitle: news.headline, newsURL: news.url)
                        }
                }
            }
            .padding()
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            }
            )
        }
    }
    
    func shareOnTwitter(newsTitle: String, newsURL: String) {
        // Construct the tweet text with the news title and URL
        let tweetText = "\(newsTitle): \(newsURL)"
        if let url = URL(string: "https://twitter.com/intent/tweet?text=\(tweetText)") {
            UIApplication.shared.open(url)
        }
    }
    
    func shareOnFacebook(newsTitle: String, newsURL: String) {
        // Construct the post text with the news title and URL
        let postText = "\(newsTitle): \(newsURL)"
        if let url = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(newsURL)") {
            UIApplication.shared.open(url)
        }
    }
    
    func formattedDate(_ datetime: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let date = Date(timeIntervalSince1970: datetime)
        return dateFormatter.string(from: date)
    }
}


#Preview {
    NewsArticleRow(article: NewsArticle(category: "company", datetime: 1714288946.0, headline: "Wall Street Breakfast: The Week Ahead", id: 127283245, image: "https://static.seekingalpha.com/cdn/s3/uploads/getty_images/2099872675/image_2099872675.jpg?io=getty-c-w1536", related: "AAPL", source: "SeekingAlpha", summary: "This article discusses the upcoming events in the financial world, including the Federal Reserve meeting, corporate earnings, IPOs, and investor events.", url: "https://finnhub.io/api/news?id=7be97f283d93041833ca7fa1618b6ac8f1ae4baee4b9c7769a9c7367dd3afaa9"))
}
