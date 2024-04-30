//
//  WebView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/29/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var htmlFilename: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let filePath = Bundle.main.path(forResource: htmlFilename, ofType: "html"),
              let htmlString = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            print("Unable to read the HTML file.")
            return
        }
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
}


#Preview {
    WebView(htmlFilename: "Charts")
}
