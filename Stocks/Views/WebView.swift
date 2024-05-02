import SwiftUI
import WebKit

struct ChartsWebView: UIViewRepresentable {
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
        var parent: ChartsWebView

        init(_ parent: ChartsWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let jsCode = "loadChartWithData('\(self.parent.ticker)');"
            print(jsCode)
            webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                if let result = result {
                    print(result)
                    print("HEY")
                }
                if let error = error {
                    print("JavaScript execution error: \(error.localizedDescription)")
                }
            })
        }
    }
}

struct HourlyChartsWebView: UIViewRepresentable {
    var htmlFilename: String
    var ticker: String
    var color: String
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
        var parent: HourlyChartsWebView

        init(_ parent: HourlyChartsWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let jsCode = "loadChartWithData('\(self.parent.ticker)', '\(self.parent.color)');"
            print(jsCode)
            webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                if let result = result {
                    print(result)
                    print("HEY")
                }
                if let error = error {
                    print("JavaScript execution error: \(error.localizedDescription)")
                }
            })
        }
    }
}

#Preview {
//    ChartsWebView(htmlFilename: "SupriseChart", ticker: "TSLA")
    HourlyChartsWebView(htmlFilename: "HourlyCharts", ticker: "TSLA", color: "true")
    
}
