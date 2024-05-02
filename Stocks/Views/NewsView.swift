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
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(){
                        Text(article.source)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text(timeAgo(from: article.datetime))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }.frame(alignment: .leading)
                    Text(article.headline)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                AsyncImage(url: URL(string: article.image)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 120, height: 90) // Adjusted size
                .cornerRadius(10)
                .padding(.trailing, 8)
            }
        }
        .sheet(isPresented: $showingNewsDetailsSheet) {
            NewsDetailView(news: article)
        }
    }
    
    func timeAgo(from datetime: TimeInterval) -> String {
        let publicationDate = Date(timeIntervalSince1970: datetime)
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: publicationDate, to: currentDate)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
        if year > 0 {
            return "\(year) year\(year > 1 ? "s" : "") ago"
        } else if month > 0 {
            return "\(month) month\(month > 1 ? "s" : "") ago"
        } else if day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        } else if hour > 0 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        } else if minute > 0 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        } else {
            return "Just now"
        }
    }
    
}


struct NewsDetailView: View {
    let news: NewsArticle
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(news.source.uppercased())
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(formattedDate(news.datetime))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text(news.headline)
                        .font(.title2)
                        .fontWeight(.bold).lineLimit(2).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    Text(news.summary)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    HStack{
                        Text("For more details click").foregroundColor(.secondary)
                        Link(destination: URL(string: news.url)!) {
                            Text("here")
                                .foregroundColor(.blue)
                        }
                    }
                    HStack {
                        Image("TwitterIcon")
                            .resizable()// Use the name of your image set
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                shareOnTwitter(newsTitle: news.headline, newsURL: news.url)
                            }
                        
                        Image("FacebookIcon") // Use the name of your image set
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                shareOnFacebook(newsTitle: news.headline, newsURL: news.url)
                            }
                    }
                    
                }
                .padding()
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.secondary)
                })
            }
        }
    }
    
    func formattedDate(_ datetime: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: datetime))
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
        print("Sharing on facebook")
        let postText = "\(newsTitle): \(newsURL)"
        if let url = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(newsURL)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NewsArticleRow(article: NewsArticle(category: "company", datetime: 1714288946.0, headline: "Wall Street Breakfast: The Week Ahead", id: 127283245, image: "https://static.seekingalpha.com/cdn/s3/uploads/getty_images/2099872675/image_2099872675.jpg?io=getty-c-w1536", related: "AAPL", source: "SeekingAlpha", summary: "This article discusses the upcoming events in the financial world, including the Federal Reserve meeting, corporate earnings, IPOs, and investor events.", url: "https://finnhub.io/api/news?id=7be97f283d93041833ca7fa1618b6ac8f1ae4baee4b9c7769a9c7367dd3afaa9"))
}
