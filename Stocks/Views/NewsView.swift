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
                    
                }
                Divider()
                Text(news.headline)
                    .font(.headline)
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

//
//#Preview {
//    NewsArticleRow(article: )
//}
