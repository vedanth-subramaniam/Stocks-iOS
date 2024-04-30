import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var htmlFilename: String
    var ticker: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let filePath = Bundle.main.url(forResource: htmlFilename, withExtension: "html") {
            let request = URLRequest(url: filePath)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let jsCode = "loadChartWithData('\(self.parent.ticker)');"
            webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                if let error = error {
                    print("JavaScript execution error: \(error.localizedDescription)")
                }
            })
        }
    }
}
#Preview {
    WebView(htmlFilename: "Charts", ticker: "TSLA")
}
